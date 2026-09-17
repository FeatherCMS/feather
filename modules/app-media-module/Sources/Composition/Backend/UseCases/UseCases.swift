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
        public let assetId: String
        public let variantId: String
        public let name: String
        public let `extension`: String
        public let objectKey: String
    }

    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let mediaStorageRootPath: String
    let storageShardConfiguration: MediaStorageShardConfiguration
    let variantQueue: any MediaVariantQueue
    let authorizer: any Authorizer

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        mediaStorageRootPath: String,
        authorizer: any Authorizer,
        variantQueue: any MediaVariantQueue,
        storageShardConfiguration: MediaStorageShardConfiguration = .init()
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.mediaStorageRootPath = mediaStorageRootPath
        self.storageShardConfiguration = storageShardConfiguration
        self.variantQueue = variantQueue
        self.authorizer = authorizer
    }

    func storage() -> any MediaStorage {
        MediaStorageClient(
            client: StorageClientFS(rootPath: mediaStorageRootPath),
            shardConfiguration: storageShardConfiguration
        )
    }

    func writeTransaction() -> DatabaseTransactionExecutor<WriteMedia> {
        DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMedia(
                    folders: MediaAssetNodeFolderDatabaseRepository(context: context),
                    assets: MediaAssetNodeFileDatabaseRepository(context: context),
                    storageObjects: MediaAssetStorageObjectDatabaseRepository(context: context),
                    variants: MediaAssetNodeFileVariantDatabaseRepository(context: context),
                    variantDefinitions: MediaVariantDatabaseRepository(context: context),
                    variantProcessors: MediaVariantProcessorDatabaseRepository(context: context)
                )
            }
        )
    }

    public func enqueueVariantGeneration(assetId: String, processors: [MediaVariantProcessor]) async throws {
        for processor in processors {
            try await variantQueue.enqueueMediaGenerateVariant(
                assetId: assetId,
                variantProcessorId: processor.id
            )
        }
    }

    public func createAssetAndEnqueue(subject: Subject, input: CreateMediaAsset.Input) async throws -> MediaAssetDetail {
        let result = try await makeCreateAsset().execute(subject: subject, input: input)
        return try await finalizeAssetCreation(result: result, input: input)
    }

    public func createAssetAndEnqueue(input: CreateMediaAsset.Input) async throws -> MediaAssetDetail {
        let result = try await makeCreateAsset().execute(input: input)
        return try await finalizeAssetCreation(result: result, input: input)
    }

    private func finalizeAssetCreation(result: MediaAssetDetail, input: CreateMediaAsset.Input) async throws -> MediaAssetDetail {
        let processors = try await database.withConnection { connection in
            let repo = MediaVariantProcessorDatabaseRepository(context: .init(connection: connection, idGenerator: idGenerator))
            return try await repo.listActive().filter {
                MediaExtensionMatcher.matches(extension: input.extension, processor: $0)
            }
        }
        let updated = try await database.withConnection { connection in
            let repo = MediaAssetNodeFileDatabaseRepository(context: .init(connection: connection, idGenerator: idGenerator))
            guard let asset = try await repo.find(id: result.id) else { return result }
            var value = asset; value.status = processors.isEmpty ? .ready : .processing
            return try await repo.update(value).asDetail
        }
        if !processors.isEmpty { try await enqueueVariantGeneration(assetId: result.id, processors: processors) }
        return updated
    }

    public func deleteAssetNodesAndFiles(subject: Subject, assetIds: [String]) async throws -> [String] { try await makeRemoveAsset().execute(subject: subject, input: .init(ids: assetIds)) }

    public func getAssetDetails(id: String) async throws -> MediaAssetDetail {
        try await database.withConnection { connection in try await MediaAssetDatabaseQueries(context: .init(connection: connection)).find(id: id) }
    }

    public func readOriginalAssetFile(assetId: String) async throws -> (data: Data, type: String, filename: String, slugPath: String) {
        let asset = try await database.withConnection { connection in try await MediaAssetDatabaseQueries(context: .init(connection: connection)).find(id: assetId) }
        return (try await storage().download(key: objectKey(for: asset)), asset.contentType, "\(asset.name).\(asset.extension)", asset.slugPath)
    }

    public func readVariantFile(assetId: String, variantName: String) async throws -> (data: Data, type: String, filename: String) {
        let variant = try await database.withConnection { connection in
            let repo = MediaAssetNodeFileVariantDatabaseRepository(context: .init(connection: connection, idGenerator: idGenerator))
            guard let value = try await repo.list(nodeId: assetId).first(where: { $0.name == variantName }) else { throw RepositoryError.notFound }
            return value
        }
        return (try await storage().download(key: variant.objectKey), mediaType(for: variant.extension), "\(variant.name).\(variant.extension)")
    }

    public func listAssociatedVariantFiles(assetId: String) async throws -> [AssociatedVariantFile] {
        try await database.withConnection { connection in
            let repo = MediaAssetNodeFileVariantDatabaseRepository(context: .init(connection: connection, idGenerator: idGenerator))
            guard try await MediaAssetNodeFileDatabaseRepository(context: .init(connection: connection, idGenerator: idGenerator)).find(id: assetId) != nil else { throw RepositoryError.notFound }
            return try await repo.list(nodeId: assetId).map { .init(assetId: assetId, variantId: $0.variantId, name: $0.name, extension: $0.extension, objectKey: $0.objectKey) }
        }
    }

    private func objectKey(for asset: MediaAssetDetail) -> String {
        MediaStorageObjectKey.original(
            assetID: asset.id,
            fileExtension: asset.extension
        )
    }
}

private func mediaType(for extension: String) -> String {
    switch `extension`.lowercased() { case "jpg", "jpeg": "image/jpeg"; case "png": "image/png"; case "gif": "image/gif"; case "webp": "image/webp"; case "pdf": "application/pdf"; case "mp4": "video/mp4"; default: "application/octet-stream" }
}
