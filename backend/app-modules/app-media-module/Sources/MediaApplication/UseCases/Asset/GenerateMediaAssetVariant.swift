import Application
import Foundation
import MediaDomain

public struct GenerateMediaAssetVariant: UseCase {
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

    let transaction: any TransactionExecutor<WriteMedia>
    let idGenerator: any IDGenerator
    let storage: any MediaStorage
    let shellRunner: any MediaShellRunner

    public init(
        transaction: any TransactionExecutor<WriteMedia>,
        idGenerator: any IDGenerator,
        storage: any MediaStorage,
        shellRunner: any MediaShellRunner
    ) {
        self.transaction = transaction
        self.idGenerator = idGenerator
        self.storage = storage
        self.shellRunner = shellRunner
    }

    public struct Input: DTO {
        public let assetId: String
        public let processorId: String

        public init(assetId: String, processorId: String) {
            self.assetId = assetId
            self.processorId = processorId
        }
    }

    public func execute(
        input: Input
    ) async throws {
        let asset = try await transaction.run { context in
            guard let found = try await context.assets.find(id: input.assetId)
            else {
                throw Error.assetNotFound
            }
            return found
        }

        let processor = try await transaction.run { context in
            try await context.processors.find(id: input.processorId)
        }

        guard let processor else {
            try await refreshAssetStatus(assetId: asset.id)
            return
        }

        guard MediaExtensionMatcher.matches(asset: asset, processor: processor)
        else {
            try await refreshAssetStatus(assetId: asset.id)
            return
        }

        let alreadyLinked = try await transaction.run { context in
            try await context.processorAssets.find(
                assetId: asset.id,
                processorId: processor.id
            ) != nil
        }
        if alreadyLinked {
            try await refreshAssetStatus(assetId: asset.id)
            return
        }

        let originalData = try await downloadOriginalAssetData(asset: asset)
        let outputExtension = try await runProcessor(
            processor,
            asset: asset,
            inputData: originalData
        )
        let outputStorageKey = outputStorageKey(
            for: asset,
            processor: processor,
            outputExtension: outputExtension
        )
        _ = try await transaction.run { context in
            try await context.processorAssets.insert(
                MediaProcessorAsset.create(
                    id: idGenerator.generate(),
                    assetId: asset.id,
                    processorId: processor.id,
                    storageKey: outputStorageKey
                )
            )
        }

        try await refreshAssetStatus(assetId: asset.id)
    }
}

private extension GenerateMediaAssetVariant {
    func downloadOriginalAssetData(
        asset: MediaAsset
    ) async throws -> Data {
        var candidates: [String] = [asset.storageKey]
        if let expanded = expandedStorageKey(asset: asset),
            expanded != asset.storageKey
        {
            candidates.append(expanded)
        }

        var lastError: Swift.Error?
        for candidate in candidates {
            do {
                return try await storage.download(key: candidate)
            }
            catch {
                lastError = error
            }
        }

        throw lastError ?? GenerateMediaAssetVariant.Error.assetNotFound
    }

    func expandedStorageKey(
        asset: MediaAsset
    ) -> String? {
        guard
            let normalizedType = MediaExtensionMatcher.canonicalExtension(
                from: asset.type
            )
        else {
            return nil
        }
        guard !normalizedType.isEmpty else { return nil }
        guard MediaExtensionMatcher.storageKeyExtension(asset.storageKey) == nil
        else { return nil }
        return "\(asset.storageKey).\(normalizedType)"
    }

    func outputStorageKey(
        for asset: MediaAsset,
        processor: MediaProcessor,
        outputExtension: String? = nil
    ) -> String {
        let resolvedExtension =
            outputExtension
            ?? MediaExtensionMatcher.canonicalExtension(from: asset.type)
            ?? MediaExtensionMatcher.storageKeyExtension(asset.storageKey)
            ?? "bin"
        let baseStorageKey = baseStorageKey(for: asset.storageKey)
        return "\(baseStorageKey)_\(processor.name).\(resolvedExtension)"
    }

    func baseStorageKey(
        for storageKey: String
    ) -> String {
        guard let slashIndex = storageKey.lastIndex(of: "/") else {
            return stripExtension(from: storageKey)
        }
        let prefix = storageKey[..<storageKey.index(after: slashIndex)]
        let fileName = String(
            storageKey[storageKey.index(after: slashIndex)...]
        )
        return String(prefix) + stripExtension(from: fileName)
    }

    func stripExtension(
        from fileName: String
    ) -> String {
        guard let dotIndex = fileName.lastIndex(of: "."),
            dotIndex > fileName.startIndex
        else {
            return fileName
        }
        return String(fileName[..<dotIndex])
    }

    func runProcessor(
        _ processor: MediaProcessor,
        asset: MediaAsset,
        inputData: Data
    ) async throws -> String {
        let inputExtension =
            MediaExtensionMatcher.canonicalExtension(from: asset.type)
            ?? MediaExtensionMatcher.storageKeyExtension(asset.storageKey)
            ?? "bin"
        let inputURL = try writeTempFile(data: inputData, ext: inputExtension)
        let outputURL = tempFileURL(ext: inputExtension)
        defer {
            try? FileManager.default.removeItem(at: inputURL)
        }

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

        let resolvedOutputURL = try resolveOutputURL(preferredURL: outputURL)
        defer {
            try? FileManager.default.removeItem(at: resolvedOutputURL)
        }

        guard FileManager.default.fileExists(atPath: resolvedOutputURL.path)
        else {
            throw Error.outputMissing(processorName: processor.name)
        }

        let outputData = try Data(contentsOf: resolvedOutputURL)
        let outputExtension =
            resolvedOutputURL.pathExtension.isEmpty
            ? inputExtension
            : resolvedOutputURL.pathExtension
        try await storage.upload(
            key: outputStorageKey(
                for: asset,
                processor: processor,
                outputExtension: outputExtension
            ),
            data: outputData
        )
        return outputExtension
    }

    func refreshAssetStatus(
        assetId: String
    ) async throws {
        let asset = try await transaction.run { context in
            guard let found = try await context.assets.find(id: assetId) else {
                throw Error.assetNotFound
            }
            return found
        }

        let processors = try await transaction.run { context in
            try await context.processors.listActive()
                .filter {
                    MediaExtensionMatcher.matches(asset: asset, processor: $0)
                }
        }

        let linkedProcessorIds = try await transaction.run { context in
            Set(
                try await context.processorAssets.list(assetId: asset.id)
                    .map(\.processorId)
            )
        }

        let updatedStatus: MediaAsset.Status
        if processors.isEmpty {
            updatedStatus = .ready
        }
        else if processors.allSatisfy({ linkedProcessorIds.contains($0.id) }) {
            updatedStatus = .ready
        }
        else {
            updatedStatus = .processing
        }

        var updated = asset
        updated.status = updatedStatus
        let updatedAsset = updated
        _ = try await transaction.run { context in
            try await context.assets.update(updatedAsset)
        }
    }

    func render(
        template: String,
        inputPath: String,
        outputPath: String
    ) -> String {
        let inputURL = URL(fileURLWithPath: inputPath)
        let outputURL = URL(fileURLWithPath: outputPath)

        var values: [String: String] = [:]
        values["input.fullname"] = inputPath
        values["input.dirname"] = inputURL.deletingLastPathComponent().path
        values["input.filename"] = inputURL.lastPathComponent
        values["input.basename"] =
            inputURL.deletingPathExtension().lastPathComponent
        values["input.extension"] = inputURL.pathExtension

        values["output.fullname"] = outputPath
        values["output.dirname"] = outputURL.deletingLastPathComponent().path
        values["output.filename"] = outputURL.lastPathComponent
        values["output.basename"] =
            outputURL.deletingPathExtension().lastPathComponent
        values["output.extension"] = outputURL.pathExtension

        return values.reduce(template) { partial, item in
            partial.replacingOccurrences(of: "{\(item.key)}", with: item.value)
        }
    }

    func tempFileURL(
        ext: String
    ) -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(ext)
    }

    func resolveOutputURL(
        preferredURL: URL
    ) throws -> URL {
        if FileManager.default.fileExists(atPath: preferredURL.path) {
            return preferredURL
        }

        let outputDirectory = preferredURL.deletingLastPathComponent()
        let outputBaseName = preferredURL.deletingPathExtension()
            .lastPathComponent
        let candidates = try FileManager.default
            .contentsOfDirectory(
                at: outputDirectory,
                includingPropertiesForKeys: nil
            )
            .filter { candidate in
                candidate.deletingPathExtension().lastPathComponent
                    == outputBaseName
            }

        if let exactMatch = candidates.first(where: {
            $0.pathExtension == preferredURL.pathExtension
        }) {
            return exactMatch
        }
        if candidates.count == 1, let candidate = candidates.first {
            return candidate
        }

        return preferredURL
    }

    func writeTempFile(
        data: Data,
        ext: String
    ) throws -> URL {
        let url = tempFileURL(ext: ext)
        try data.write(to: url)
        return url
    }
}
