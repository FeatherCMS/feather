import FeatherApplication
import FeatherContracts
import FeatherStorage
import Foundation
import MediaDomain

public struct GenerateMediaAssetVariants: UseCase {
    public enum Error: UseCaseError {
        case assetNotFound
        case outputMissing(processorName: String)
        case commandFailed(
            processorName: String,
            command: String,
            status: Int32,
            stderr: String?
        )
    }

    private struct Prepared: Sendable {
        let asset: MediaAssetNodeFile
        let plans: [Plan]
        let requiredVariantIDs: Set<String>
        let applicableVariantIDs: Set<String>
        let generatedVariantIDs: Set<String>
    }

    private struct Plan: Sendable {
        let processor: MediaVariantProcessor
        let variant: MediaVariant
    }

    private struct Output: Sendable {
        let assetID: String
        let plan: Plan
        let `extension`: String

        var objectKey: String {
            MediaStorageObjectKey.variant(
                assetID: assetID,
                variantKey: plan.variant.key,
                fileExtension: `extension`
            )
        }
    }

    let transaction: any TransactionExecutor<WriteMedia>
    let storage: any StorageClient
    let storageKeyShard: MediaStorageKeyShard
    let shellRunner: any MediaShellRunner

    public init(
        transaction: any TransactionExecutor<WriteMedia>,
        storage: any StorageClient,
        storageKeyShard: MediaStorageKeyShard = .init(),
        shellRunner: any MediaShellRunner
    ) {
        self.transaction = transaction
        self.storage = storage
        self.storageKeyShard = storageKeyShard
        self.shellRunner = shellRunner
    }

    public struct Input: DTO {
        public let assetId: String

        public init(assetId: String) {
            self.assetId = assetId
        }
    }

    public func execute(input: Input) async throws {
        let prepared = try await prepare(assetID: input.assetId)
        do {
            try await execute(prepared: prepared)
        }
        catch {
            // A failed job must not leave the asset looking permanently busy.
            // The queue can retry the job, and the uploaded state accurately
            // describes that the original file is still available.
            try? await updateStatus(
                assetID: prepared.asset.id,
                status: .uploaded
            )
            throw error
        }
    }

    private func execute(prepared: Prepared) async throws {
        guard !prepared.plans.isEmpty else {
            try await updateStatus(
                assetID: prepared.asset.id,
                status: .ready
            )
            return
        }

        let inputData = try await MediaStorageData.download(
            from: storage,
            key: storageKeyShard.physicalKey(for: prepared.asset.objectKey)
        )
        let inputExtension =
            MediaExtensionMatcher.canonicalExtension(
                from: prepared.asset.extension
            ) ?? "bin"
        let inputURL = try temporaryFile(
            data: inputData,
            extension: inputExtension
        )
        defer { try? FileManager.default.removeItem(at: inputURL) }
        var outputs: [Output] = []
        outputs.reserveCapacity(prepared.plans.count)
        var uploadedKeys: [String] = []
        do {
            for plan in prepared.plans {
                let output = try await runProcessor(
                    plan.processor,
                    asset: prepared.asset,
                    inputURL: inputURL
                )
                let generated = Output(
                    assetID: prepared.asset.id,
                    plan: plan,
                    extension: output.extension
                )
                try await MediaStorageData.upload(
                    output.data,
                    to: storage,
                    key: storageKeyShard.physicalKey(for: generated.objectKey)
                )
                uploadedKeys.append(generated.objectKey)
                outputs.append(generated)
            }
        }
        catch {
            await deleteUploaded(keys: uploadedKeys)
            throw error
        }

        let generatedOutputs = outputs
        do {
            try await transaction.run { scope in
                let storageObjects = try await scope.storageObjects.insert(
                    generatedOutputs.map {
                        MediaAssetStorageObject.create(objectKey: $0.objectKey)
                    }
                )
                let storageObjectIDs = Dictionary(
                    uniqueKeysWithValues: storageObjects.map {
                        ($0.objectKey, $0.id)
                    }
                )
                let variants = try generatedOutputs.map { output in
                    guard
                        let storageObjectID = storageObjectIDs[output.objectKey]
                    else { throw Error.assetNotFound }
                    return MediaAssetNodeFileVariant.create(
                        nodeId: prepared.asset.id,
                        variantId: output.plan.variant.id,
                        variantProcessorId: output.plan.processor.id,
                        name: output.plan.variant.key,
                        storageObjectId: storageObjectID,
                        objectKey: output.objectKey,
                        extension: output.extension
                    )
                }
                try await scope.variants.insert(variants)
            }
        }
        catch {
            await deleteUploaded(keys: uploadedKeys)
            throw error
        }

        let generatedVariantIDs = prepared.generatedVariantIDs.union(
            outputs.map { $0.plan.variant.id }
        )
        let pending = prepared.requiredVariantIDs.contains { variantID in
            prepared.applicableVariantIDs.contains(variantID)
                && !generatedVariantIDs.contains(variantID)
        }
        try await updateStatus(
            assetID: prepared.asset.id,
            status: pending ? .processing : .ready
        )
    }
}

extension GenerateMediaAssetVariants {
    private func prepare(assetID: String) async throws -> Prepared {
        try await transaction.run { scope in
            guard let asset = try await scope.assets.find(id: assetID) else {
                throw Error.assetNotFound
            }
            let variants = try await scope.variantDefinitions.listActive()
            let variantsByID = Dictionary(
                uniqueKeysWithValues: variants.map { ($0.id, $0) }
            )
            let processors = try await scope.variantProcessors.listActive()
            let applicableProcessors = processors.filter {
                MediaExtensionMatcher.matches(
                    extension: asset.extension,
                    processor: $0
                )
            }
            let generated = Set(
                try await scope.variants.list(nodeId: asset.id).map(\.variantId)
            )
            var seenVariantIDs: Set<String> = []
            let plans = applicableProcessors.compactMap { processor -> Plan? in
                guard
                    let variant = variantsByID[processor.variantId],
                    !generated.contains(variant.id),
                    seenVariantIDs.insert(variant.id).inserted
                else { return nil }
                return .init(processor: processor, variant: variant)
            }
            return Prepared(
                asset: asset,
                plans: plans,
                requiredVariantIDs: Set(
                    variants.filter(\.isRequired).map(\.id)
                ),
                applicableVariantIDs: Set(
                    applicableProcessors.map(\.variantId)
                ),
                generatedVariantIDs: generated
            )
        }
    }

    fileprivate func updateStatus(
        assetID: String,
        status: MediaAssetNodeFile.Status
    ) async throws {
        try await transaction.run { scope in
            try await scope.assets.updateStatus(id: assetID, status: status)
        }
    }

    fileprivate func deleteUploaded(keys: [String]) async {
        for key in keys {
            _ = try? await MediaStorageData.delete(
                from: storage,
                key: storageKeyShard.physicalKey(for: key)
            )
        }
    }

    fileprivate func runProcessor(
        _ processor: MediaVariantProcessor,
        asset: MediaAssetNodeFile,
        inputURL: URL
    ) async throws -> (data: Data, extension: String) {
        let outputURL = temporaryURL(extension: inputURL.pathExtension)
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
        return (
            try Data(contentsOf: resolvedURL),
            MediaExtensionMatcher.canonicalExtension(
                from: resolvedURL.pathExtension
            ) ?? inputURL.pathExtension
        )
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
