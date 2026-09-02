import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherStorageFS
import Foundation
import MediaApplication
import MediaDomain
import MediaInfrastructure

public struct UseCases: Sendable {
    public struct AssociatedVariantFile: Sendable {
        public let variantId: String
        public let name: String
        public let type: String
        public let storageKey: String
    }

    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let mediaStorageRootPath: String
    let variantQueue: any MediaVariantQueue
    let authorizer: any Authorizer

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        mediaStorageRootPath: String,
        authorizer: any Authorizer,
        variantQueue: any MediaVariantQueue
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.mediaStorageRootPath = mediaStorageRootPath
        self.variantQueue = variantQueue
        self.authorizer = authorizer
    }
}

extension UseCases {
    var mediaAssetKeyPrefix: String { "media/assets/" }

    func expandAssetStorageKeyIfNeeded(
        _ key: String
    ) -> String {
        key.hasPrefix(mediaAssetKeyPrefix)
            ? key : "\(mediaAssetKeyPrefix)\(key)"
    }

    func storage() -> any MediaStorage {
        MediaStorageClient(
            client: StorageClientFS(
                rootPath: mediaStorageRootPath
            )
        )
    }

    func writeTransaction() -> DatabaseTransactionExecutor<WriteMedia> {
        DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMedia(
                    folders: MediaFolderDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: idGenerator
                        )
                    ),
                    assets: MediaAssetDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: idGenerator
                        )
                    ),
                    processors: MediaProcessorDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: idGenerator
                        )
                    ),
                    processorAssets: MediaProcessorAssetDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: idGenerator
                        )
                    )
                )
            }
        )
    }

    public func enqueueVariantGeneration(
        assetId: String,
        processors: [MediaProcessor]
    ) async throws {
        for processor in processors {
            try await variantQueue.enqueueMediaGenerateVariant(
                assetId: assetId,
                processorId: processor.id
            )
        }
    }

    public func createAssetAndEnqueue(
        subject: Subject,
        input: CreateMediaAsset.Input
    ) async throws -> MediaAssetDetail {
        let result = try await makeCreateAsset()
            .execute(subject: subject, input: input)
        let matchingProcessors =
            try await database
            .withConnection { connection in
                let processorRepo = MediaProcessorDatabaseRepository(
                    context: .init(
                        connection: connection,
                        idGenerator: idGenerator
                    )
                )
                return try await processorRepo.listActive()
                    .filter {
                        MediaExtensionMatcher.matches(
                            storageKey: result.storageKey,
                            type: result.type,
                            processor: $0
                        )
                    }
            }

        guard !matchingProcessors.isEmpty else {
            return try await database.withConnection {
                connection in
                let assetRepo = MediaAssetDatabaseRepository(
                    context: .init(
                        connection: connection,
                        idGenerator: idGenerator
                    )
                )
                guard let asset = try await assetRepo.find(id: result.id) else {
                    return result
                }
                var updated = asset
                updated.status = .ready
                return try await assetRepo.update(updated).asDetail
            }
        }

        let updatedResult = try await database.withConnection {
            connection in
            let assetRepo = MediaAssetDatabaseRepository(
                context: .init(
                    connection: connection,
                    idGenerator: idGenerator
                )
            )
            guard let asset = try await assetRepo.find(id: result.id) else {
                return result
            }
            var updated = asset
            updated.status = .processing
            return try await assetRepo.update(updated).asDetail
        }

        do {
            try await enqueueVariantGeneration(
                assetId: result.id,
                processors: matchingProcessors
            )
        }
        catch {
            _ = try? await database.withConnection {
                connection in
                let assetRepo = MediaAssetDatabaseRepository(
                    context: .init(
                        connection: connection,
                        idGenerator: idGenerator
                    )
                )
                guard let asset = try await assetRepo.find(id: result.id) else {
                    return result
                }
                var reverted = asset
                reverted.status = .uploaded
                return try await assetRepo.update(reverted).asDetail
            }
            throw error
        }
        return updatedResult
    }

    public func deleteAssetAndFiles(
        subject: Subject,
        assetIds: [String]
    ) async throws -> Bool {
        for assetId in assetIds {
            let detail = try? await makeGetAssetDetails()
                .execute(
                    subject: subject,
                    input: .init(id: assetId)
                )
            let variants =
                (try? await listAssociatedVariantFiles(assetId: assetId)) ?? []
            for variant in variants {
                _ = try? await storage().delete(key: variant.storageKey)
            }
            if let detail {
                for key in originalStorageKeys(for: detail) {
                    _ = try? await storage().delete(key: key)
                }
            }
        }
        return try await makeDeleteAsset()
            .execute(
                subject: subject,
                input: .init(ids: assetIds)
            )
    }

    public func readOriginalAssetFile(
        storageKey: String
    ) async throws -> (data: Data, type: String) {
        let maybeAsset: MediaAssetDetail? =
            try await database
            .withConnection { connection -> MediaAssetDetail? in
                let queries = MediaAssetDatabaseQueries(
                    context: .init(connection: connection)
                )
                if let direct = try await queries.findByStorageKey(storageKey) {
                    return direct
                }
                let expanded = expandAssetStorageKeyIfNeeded(storageKey)
                guard expanded != storageKey else { return nil }
                return try await queries.findByStorageKey(expanded)
            }
        guard let asset = maybeAsset else {
            throw RepositoryError.notFound
        }
        let data = try await downloadOriginalAssetData(asset: asset)
        return (data: data, type: asset.type)
    }

    public func getAssetDetails(
        id: String
    ) async throws -> MediaAssetDetail {
        try await database.withConnection { connection in
            try await MediaAssetDatabaseQueries(
                context: .init(connection: connection)
            )
            .find(id: id)
        }
    }

    public func readVariantFile(
        storageKey: String
    ) async throws -> Data {
        do {
            return try await storage().download(key: storageKey)
        }
        catch {
            let expanded = expandAssetStorageKeyIfNeeded(storageKey)
            guard expanded != storageKey else { throw error }
            return try await storage().download(key: expanded)
        }
    }

    public func downloadOriginalAssetData(
        asset: MediaAssetDetail
    ) async throws -> Data {
        let storage = storage()
        var candidates: [String] = [asset.storageKey]
        if let expanded = expandedOriginalStorageKey(asset: asset),
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

        throw lastError ?? RepositoryError.notFound
    }

    public func expandedOriginalStorageKey(
        asset: MediaAssetDetail
    ) -> String? {
        let normalizedType = canonicalExtension(from: asset.type)
        guard !normalizedType.isEmpty else { return nil }
        guard storageKeyExtension(asset.storageKey) == nil else { return nil }
        return "\(asset.storageKey).\(normalizedType)"
    }

    public func canonicalExtension(
        from value: String
    ) -> String {
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        guard !normalized.isEmpty else { return "" }

        let strippedPrefix =
            normalized.hasPrefix(".")
            ? String(normalized.drop(while: { $0 == "." }))
            : normalized
        let rawExtension =
            strippedPrefix.contains("/")
            ? (strippedPrefix.split(separator: "/").last.map(String.init)
                ?? strippedPrefix)
            : strippedPrefix

        switch rawExtension {
        case "jpg", "jpeg":
            return "jpeg"
        default:
            return rawExtension
        }
    }

    public func storageKeyExtension(
        _ storageKey: String
    ) -> String? {
        let fileName =
            storageKey.split(separator: "/").last.map(String.init) ?? storageKey
        guard let dotIndex = fileName.lastIndex(of: "."),
            dotIndex < fileName.index(before: fileName.endIndex)
        else {
            return nil
        }
        let ext = String(fileName[fileName.index(after: dotIndex)...])
            .lowercased()
        return ext.isEmpty ? nil : ext
    }

    public func listAssociatedVariantFiles(
        assetId: String
    ) async throws -> [AssociatedVariantFile] {
        try await database.withConnection { connection in
            let assetRepo = MediaAssetDatabaseRepository(
                context: .init(
                    connection: connection,
                    idGenerator: idGenerator
                )
            )
            guard try await assetRepo.find(id: assetId) != nil else {
                throw RepositoryError.notFound
            }

            let processorAssetRepo = MediaProcessorAssetDatabaseRepository(
                context: .init(
                    connection: connection,
                    idGenerator: idGenerator
                )
            )
            let processorRepo = MediaProcessorDatabaseRepository(
                context: .init(
                    connection: connection,
                    idGenerator: idGenerator
                )
            )
            let links = try await processorAssetRepo.list(assetId: assetId)

            var results: [AssociatedVariantFile] = []
            results.reserveCapacity(links.count)
            for link in links {
                guard
                    let processor = try await processorRepo.find(
                        id: link.processorId
                    )
                else {
                    continue
                }
                results.append(
                    .init(
                        variantId: processor.id,
                        name: processor.name,
                        type: "processor",
                        storageKey: link.storageKey
                    )
                )
            }
            return results.sorted { lhs, rhs in
                lhs.name.localizedCaseInsensitiveCompare(rhs.name)
                    == .orderedAscending
            }
        }
    }

    public func composeAssetStorageKey(
        fileName: String,
        type: String,
        folderId: String?
    ) async throws -> (folderId: String?, storageKey: String) {
        let folder: MediaFolder? =
            try await database
            .withConnection { connection -> MediaFolder? in
                guard let folderId else { return nil }
                return try await MediaFolderDatabaseRepository(
                    context: .init(
                        connection: connection,
                        idGenerator: idGenerator
                    )
                )
                .find(id: folderId)
            }

        let resolvedExtension =
            canonicalExtension(from: type)
            .ifEmpty(
                fallback: storageKeyExtension(fileName) ?? "bin"
            )
        let sanitizedFileName = sanitizeFileName(
            fileName,
            fallbackExtension: resolvedExtension
        )
        let relativePath =
            folder.map { "\($0.path)/\(sanitizedFileName)" }
            ?? sanitizedFileName
        return (
            folderId: folder?.id,
            storageKey: "\(mediaAssetKeyPrefix)\(relativePath)"
        )
    }
}

extension UseCases {
    fileprivate func sanitizeFileName(
        _ value: String,
        fallbackExtension: String
    ) -> String {
        let raw = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let pieces = raw.split(separator: "/").last.map(String.init) ?? raw
        let dotIndex = pieces.lastIndex(of: ".")
        let baseName =
            dotIndex.map { String(pieces[..<$0]) }
            .flatMap { $0.isEmpty ? nil : $0 }
            ?? pieces
        let normalizedBase =
            baseName
            .lowercased()
            .replacingOccurrences(
                of: #"[^a-z0-9._-]+"#,
                with: "-",
                options: .regularExpression
            )
            .trimmingCharacters(in: CharacterSet(charactersIn: "-._"))
        let safeBase = normalizedBase.isEmpty ? "asset" : normalizedBase
        let ext =
            storageKeyExtension(pieces)
            ?? fallbackExtension.trimmingCharacters(in: .whitespacesAndNewlines)
        return ext.isEmpty ? safeBase : "\(safeBase).\(ext.lowercased())"
    }

    fileprivate func originalStorageKeys(
        for asset: MediaAssetDetail
    ) -> [String] {
        var keys = [asset.storageKey]
        if let expanded = expandedOriginalStorageKey(asset: asset),
            expanded != asset.storageKey
        {
            keys.append(expanded)
        }
        return keys
    }
}

extension String {
    fileprivate func ifEmpty(
        fallback: String
    ) -> String {
        isEmpty ? fallback : self
    }
}
