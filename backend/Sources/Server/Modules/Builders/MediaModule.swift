import Application
import FeatherDatabase
import FeatherStorageFS
import Foundation
import Infrastructure
import MediaApplication
import MediaDomain
import MediaInfrastructure

struct MediaModule: Sendable {
    struct AssociatedVariantFile: Sendable {
        let variantId: String
        let name: String
        let type: String
        let storageKey: String
    }

    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    init(
        infrastructure: AppInfrastructure,
        authorizer: any Authorizer
    ) {
        self.infrastructure = infrastructure
        self.authorizer = authorizer
    }
}

extension MediaModule {
    private var mediaAssetKeyPrefix: String { "media/assets/" }

    private func expandAssetStorageKeyIfNeeded(
        _ key: String
    ) -> String {
        key.hasPrefix(mediaAssetKeyPrefix)
            ? key : "\(mediaAssetKeyPrefix)\(key)"
    }

    private func storage() -> any MediaStorage {
        MediaStorageClient(
            client: StorageClientFS(
                rootPath: infrastructure.mediaStorageRootPath
            )
        )
    }

    private func writeTransaction() -> DatabaseTransactionExecutor<WriteMedia> {
        DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteMedia(
                    folders: DatabaseMediaFolderRepository(
                        connection: connection
                    ),
                    assets: DatabaseMediaAssetRepository(
                        connection: connection
                    ),
                    processors: DatabaseMediaProcessorRepository(
                        connection: connection
                    ),
                    processorAssets: DatabaseMediaProcessorAssetRepository(
                        connection: connection
                    )
                )
            }
        )
    }

    func enqueueVariantGeneration(
        assetId: String,
        processors: [MediaProcessor]
    ) async throws {
        for processor in processors {
            try await infrastructure.jobQueue.enqueueMediaGenerateVariant(
                assetId: assetId,
                processorId: processor.id
            )
        }
    }

    func makeCreateAsset() -> CreateMediaAsset {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(),
            idGenerator: infrastructure.idGenerator,
            storage: storage()
        )
    }

    func createAssetAndEnqueue(
        subject: Subject,
        input: CreateMediaAsset.Input
    ) async throws -> MediaAssetDetail {
        let result = try await makeCreateAsset()
            .execute(subject: subject, input: input)
        let matchingProcessors = try await infrastructure.database
            .withConnection { connection in
                let processorRepo = DatabaseMediaProcessorRepository(
                    connection: connection
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
            return try await infrastructure.database.withConnection {
                connection in
                let assetRepo = DatabaseMediaAssetRepository(
                    connection: connection
                )
                guard let asset = try await assetRepo.find(id: result.id) else {
                    return result
                }
                var updated = asset
                updated.status = .ready
                return try await assetRepo.update(updated).asDetail
            }
        }

        let updatedResult = try await infrastructure.database.withConnection {
            connection in
            let assetRepo = DatabaseMediaAssetRepository(connection: connection)
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
            _ = try? await infrastructure.database.withConnection {
                connection in
                let assetRepo = DatabaseMediaAssetRepository(
                    connection: connection
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

    func makeSearchAssets() -> SearchMediaAssets {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMedia(
                    folders: DatabaseMediaFolderQueries(connection: connection),
                    assets: DatabaseMediaAssetQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeGetAssetDetails() -> GetMediaAssetDetails {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMedia(
                    folders: DatabaseMediaFolderQueries(connection: connection),
                    assets: DatabaseMediaAssetQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeDeleteAsset() -> DeleteMediaAsset {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }

    func deleteAssetAndFiles(
        subject: Subject,
        assetId: String
    ) async throws -> Bool {
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
        return try await makeDeleteAsset()
            .execute(
                subject: subject,
                input: .init(id: assetId)
            )
    }

    func makeEditAsset() -> EditMediaAsset {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }

    func makeCreateFolder() -> CreateMediaFolder {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(),
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeListFolders() -> ListMediaFolders {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMedia(
                    folders: DatabaseMediaFolderQueries(connection: connection),
                    assets: DatabaseMediaAssetQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeGetFolder() -> GetMediaFolder {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMedia(
                    folders: DatabaseMediaFolderQueries(connection: connection),
                    assets: DatabaseMediaAssetQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeEditFolder() -> EditMediaFolder {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }

    func makeDeleteFolder() -> DeleteMediaFolder {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(),
            storage: storage()
        )
    }

    func makeCreateProcessor() -> CreateMediaProcessor {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(),
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeSearchProcessors() -> SearchMediaProcessors {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }

    func makeGetProcessor() -> GetMediaProcessor {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }

    func makeEditProcessor() -> EditMediaProcessor {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }

    func makeDeleteProcessor() -> DeleteMediaProcessor {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }

    func readOriginalAssetFile(
        storageKey: String
    ) async throws -> (data: Data, type: String) {
        let maybeAsset: MediaAssetDetail? = try await infrastructure.database
            .withConnection { connection in
                let queries = DatabaseMediaAssetQueries(connection: connection)
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

    func getAssetDetails(
        id: String
    ) async throws -> MediaAssetDetail {
        try await infrastructure.database.withConnection { connection in
            try await DatabaseMediaAssetQueries(connection: connection)
                .find(id: id)
        }
    }

    func readVariantFile(
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

    func downloadOriginalAssetData(
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

    func expandedOriginalStorageKey(
        asset: MediaAssetDetail
    ) -> String? {
        let normalizedType = canonicalExtension(from: asset.type)
        guard !normalizedType.isEmpty else { return nil }
        guard storageKeyExtension(asset.storageKey) == nil else { return nil }
        return "\(asset.storageKey).\(normalizedType)"
    }

    func canonicalExtension(
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

    func storageKeyExtension(
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

    func listAssociatedVariantFiles(
        assetId: String
    ) async throws -> [AssociatedVariantFile] {
        try await infrastructure.database.withConnection { connection in
            let assetRepo = DatabaseMediaAssetRepository(connection: connection)
            guard try await assetRepo.find(id: assetId) != nil else {
                throw RepositoryError.notFound
            }

            let processorAssetRepo = DatabaseMediaProcessorAssetRepository(
                connection: connection
            )
            let processorRepo = DatabaseMediaProcessorRepository(
                connection: connection
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

    func composeAssetStorageKey(
        fileName: String,
        type: String,
        folderId: String?
    ) async throws -> (folderId: String?, storageKey: String) {
        let folder: MediaFolder? = try await infrastructure.database
            .withConnection { connection in
                guard let folderId else { return nil }
                return try await DatabaseMediaFolderRepository(
                    connection: connection
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

private extension MediaModule {
    func sanitizeFileName(
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

    func originalStorageKeys(
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

private extension String {
    func ifEmpty(
        fallback: String
    ) -> String {
        isEmpty ? fallback : self
    }
}
