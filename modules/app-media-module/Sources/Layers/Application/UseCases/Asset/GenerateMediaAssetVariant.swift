import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import MediaDomain

public struct GenerateMediaAssetVariant: UseCase {
    public enum Error: UseCaseError {
        case assetNotFound
        case variantProcessorNotFound
        case outputMissing(processorName: String)
        case commandFailed(
            processorName: String,
            command: String,
            status: Int32,
            stderr: String?
        )
    }

    let transaction: any TransactionExecutor<WriteMedia>
    let storage: any MediaStorage
    let shellRunner: any MediaShellRunner

    public init(
        transaction: any TransactionExecutor<WriteMedia>,
        storage: any MediaStorage,
        shellRunner: any MediaShellRunner
    ) {
        self.transaction = transaction
        self.storage = storage
        self.shellRunner = shellRunner
    }

    public struct Input: DTO {
        public let assetId: String
        public let variantProcessorId: String

        public init(assetId: String, variantProcessorId: String) {
            self.assetId = assetId
            self.variantProcessorId = variantProcessorId
        }
    }

    public func execute(input: Input) async throws {
        let asset = try await transaction.run { scope in
            guard let asset = try await scope.assets.find(id: input.assetId)
            else {
                throw Error.assetNotFound
            }
            return asset
        }
        guard
            let processor = try await transaction.run({ scope in
                try await scope.variantProcessors.find(
                    id: input.variantProcessorId
                )
            })
        else {
            try await refreshStatus(assetId: asset.id)
            throw Error.variantProcessorNotFound
        }
        guard processor.isActive else {
            try await refreshStatus(assetId: asset.id)
            return
        }
        guard
            MediaExtensionMatcher.matches(
                extension: asset.extension,
                processor: processor
            )
        else {
            try await refreshStatus(assetId: asset.id)
            return
        }
        guard
            let variant = try await transaction.run({ scope in
                try await scope.variantDefinitions.find(id: processor.variantId)
            })
        else {
            try await refreshStatus(assetId: asset.id)
            throw Error.variantProcessorNotFound
        }
        guard variant.isActive else {
            try await refreshStatus(assetId: asset.id)
            return
        }
        if try await transaction.run({ scope in
            try await scope.variants.find(
                nodeId: asset.id,
                variantId: variant.id
            )
        }) != nil {
            try await refreshStatus(assetId: asset.id)
            return
        }

        let inputData = try await storage.download(key: asset.objectKey)
        let output = try await runProcessor(
            processor,
            asset: asset,
            data: inputData
        )
        let objectKey = MediaStorageObjectKey.variant(
            assetID: asset.id,
            variantKey: variant.key,
            fileExtension: output.extension
        )
        try await storage.upload(key: objectKey, data: output.data)
        do {
            _ = try await transaction.run { scope in
                let storageObject = try await scope.storageObjects.insert(
                    MediaAssetStorageObject.create(objectKey: objectKey)
                )
                return try await scope.variants.insert(
                    MediaAssetNodeFileVariant.create(
                        nodeId: asset.id,
                        variantId: variant.id,
                        variantProcessorId: processor.id,
                        name: variant.key,
                        storageObjectId: storageObject.id,
                        objectKey: objectKey,
                        extension: output.extension
                    )
                )
            }
        }
        catch {
            _ = try? await storage.delete(key: objectKey)
            throw error
        }
        try await refreshStatus(assetId: asset.id)
    }
}

extension GenerateMediaAssetVariant {
    fileprivate struct Output {
        let data: Data
        let `extension`: String
    }

    fileprivate func runProcessor(
        _ processor: MediaVariantProcessor,
        asset: MediaAssetNodeFile,
        data: Data
    ) async throws -> Output {
        let inputExtension =
            MediaExtensionMatcher.canonicalExtension(from: asset.extension)
            ?? "bin"
        let inputURL = try temporaryFile(data: data, extension: inputExtension)
        let outputURL = temporaryURL(extension: inputExtension)
        defer { try? FileManager.default.removeItem(at: inputURL) }
        let command = render(
            template: processor.commandTemplate,
            inputPath: inputURL.path,
            outputPath: outputURL.path
        )
        let result = try await shellRunner.run(command: command)
        guard result.exitCode == 0 else {
            throw Error.commandFailed(
                processorName: processor.name,
                command: command,
                status: result.exitCode,
                stderr: result.standardError
            )
        }
        let resolvedURL = try resolveOutputURL(preferredURL: outputURL)
        defer { try? FileManager.default.removeItem(at: resolvedURL) }
        guard FileManager.default.fileExists(atPath: resolvedURL.path) else {
            throw Error.outputMissing(processorName: processor.name)
        }
        return .init(
            data: try Data(contentsOf: resolvedURL),
            extension: MediaExtensionMatcher.canonicalExtension(
                from: resolvedURL.pathExtension
            ) ?? inputExtension
        )
    }

    fileprivate func refreshStatus(assetId: String) async throws {
        let asset = try await transaction.run { scope in
            guard let asset = try await scope.assets.find(id: assetId) else {
                throw Error.assetNotFound
            }
            return asset
        }
        let requiredVariants = try await transaction.run { scope in
            try await scope.variantDefinitions.listActive()
                .filter { $0.isRequired }
        }
        let applicableProcessors = try await transaction.run { scope in
            try await scope.variantProcessors.listActive()
                .filter {
                    MediaExtensionMatcher.matches(
                        extension: asset.extension,
                        processor: $0
                    )
                }
        }
        let generated = Set(
            try await transaction.run { scope in
                try await scope.variants.list(nodeId: asset.id).map(\.variantId)
            }
        )
        let pending = requiredVariants.contains { variant in
            applicableProcessors.contains { $0.variantId == variant.id }
                && !generated.contains(variant.id)
        }
        let updated: MediaAssetNodeFile = {
            var asset = asset
            asset.status = pending ? .processing : .ready
            return asset
        }()
        _ = try await transaction.run { scope in
            try await scope.assets.update(updated)
        }
    }

    fileprivate func render(
        template: String,
        inputPath: String,
        outputPath: String
    ) -> String {
        let input = URL(fileURLWithPath: inputPath)
        let output = URL(fileURLWithPath: outputPath)
        let values = [
            "input.fullname": inputPath,
            "input.dirname": input.deletingLastPathComponent().path,
            "input.filename": input.lastPathComponent,
            "input.basename": input.deletingPathExtension().lastPathComponent,
            "input.extension": input.pathExtension,
            "output.fullname": outputPath,
            "output.dirname": output.deletingLastPathComponent().path,
            "output.filename": output.lastPathComponent,
            "output.basename": output.deletingPathExtension().lastPathComponent,
            "output.extension": output.pathExtension,
        ]
        return values.reduce(template) {
            $0.replacingOccurrences(of: "{\($1.key)}", with: $1.value)
        }
    }

    fileprivate func temporaryURL(extension: String) -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(`extension`)
    }

    fileprivate func temporaryFile(data: Data, extension: String) throws -> URL
    {
        let url = temporaryURL(extension: `extension`)
        try data.write(to: url)
        return url
    }

    fileprivate func resolveOutputURL(preferredURL: URL) throws -> URL {
        if FileManager.default.fileExists(atPath: preferredURL.path) {
            return preferredURL
        }
        let candidates = try FileManager.default
            .contentsOfDirectory(
                at: preferredURL.deletingLastPathComponent(),
                includingPropertiesForKeys: nil
            )
            .filter {
                $0.deletingPathExtension().lastPathComponent
                    == preferredURL.deletingPathExtension().lastPathComponent
            }
        return candidates.first(where: {
            $0.pathExtension == preferredURL.pathExtension
        })
            ?? (candidates.count == 1 ? candidates[0] : preferredURL)
    }
}
