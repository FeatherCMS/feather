import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherStorage
import Foundation
import MediaApplication
import MediaDomain
import MediaInfrastructure

public struct UseCases: Sendable {
    public struct AssociatedVariantFile: Sendable {
        public let assetId: String
        public let variantId: String
        public let key: String
        public let name: String
        public let `extension`: String
        public let objectKey: String
    }

    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let storage: any StorageClient
    let storageKeyShard: MediaStorageKeyShard
    let variantQueue: any MediaVariantQueue
    let authorizer: any Authorizer

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        storage: any StorageClient,
        authorizer: any Authorizer,
        variantQueue: any MediaVariantQueue,
        storageKeyShard: MediaStorageKeyShard = .init()
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.storage = storage
        self.storageKeyShard = storageKeyShard
        self.variantQueue = variantQueue
        self.authorizer = authorizer
    }

    func writeTransaction() -> DatabaseTransactionExecutor<WriteMedia> {
        DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMedia(
                    folders: MediaAssetNodeFolderDatabaseRepository(
                        context: context
                    ),
                    assets: MediaAssetNodeFileDatabaseRepository(
                        context: context
                    ),
                    storageObjects: MediaAssetStorageObjectDatabaseRepository(
                        context: context
                    ),
                    variants: MediaAssetNodeFileVariantDatabaseRepository(
                        context: context
                    ),
                    variantDefinitions: MediaVariantDatabaseRepository(
                        context: context
                    ),
                    variantProcessors: MediaVariantProcessorDatabaseRepository(
                        context: context
                    )
                )
            }
        )
    }

    public func enqueueVariantGeneration(
        assetId: String,
        processors: [MediaVariantProcessor]
    ) async throws {
        guard !processors.isEmpty else { return }
        try await variantQueue.enqueueMediaGenerateVariants(assetId: assetId)
    }

    public func createAssetAndEnqueue(
        subject: Subject,
        input: CreateMediaAsset.Input
    ) async throws -> MediaAssetDetail {
        let result = try await makeCreateAsset()
            .execute(subject: subject, input: input)
        let processors = try await activeVariantProcessors()
        return try await finalizeAssetCreation(
            result: result,
            input: input,
            processors: processors
        )
    }

    public func createAssetAndEnqueue(input: CreateMediaAsset.Input)
        async throws -> MediaAssetDetail
    {
        let result = try await makeCreateAsset().execute(input: input)
        let processors = try await activeVariantProcessors()
        return try await finalizeAssetCreation(
            result: result,
            input: input,
            processors: processors
        )
    }

    public func createAssetAndEnqueue(
        input: CreateMediaAsset.Input,
        processors: [MediaVariantProcessor]
    ) async throws -> MediaAssetDetail {
        let result = try await makeCreateAsset().execute(input: input)
        return try await finalizeAssetCreation(
            result: result,
            input: input,
            processors: processors
        )
    }

    public func activeVariantProcessors() async throws
        -> [MediaVariantProcessor]
    {
        try await database.withConnection { connection in
            let repo = MediaVariantProcessorDatabaseRepository(
                context: .init(connection: connection, idGenerator: idGenerator)
            )
            return try await repo.listActive()
        }
    }

    private func finalizeAssetCreation(
        result: MediaAssetDetail,
        input: CreateMediaAsset.Input,
        processors: [MediaVariantProcessor]
    ) async throws -> MediaAssetDetail {
        let matchingProcessors = processors.filter {
            MediaExtensionMatcher.matches(
                extension: input.extension,
                processor: $0
            )
        }
        let updated = try await database.withConnection { connection in
            let repo = MediaAssetNodeFileDatabaseRepository(
                context: .init(connection: connection, idGenerator: idGenerator)
            )
            guard let asset = try await repo.find(id: result.id) else {
                return result
            }
            var value = asset
            value.status = matchingProcessors.isEmpty ? .ready : .processing
            return try await repo.update(value).asDetail
        }
        if !matchingProcessors.isEmpty {
            try await enqueueVariantGeneration(
                assetId: result.id,
                processors: matchingProcessors
            )
        }
        return updated
    }

    public func deleteAssetNodesAndFiles(subject: Subject, assetIds: [String])
        async throws -> [String]
    {
        try await makeRemoveAsset()
            .execute(subject: subject, input: .init(ids: assetIds))
    }

    public func getAssetDetails(id: String) async throws -> MediaAssetDetail {
        try await database.withConnection { connection in
            try await MediaAssetDatabaseQueries(
                context: .init(connection: connection)
            )
            .find(id: id)
        }
    }

    public func readOriginalAssetFile(assetId: String) async throws -> (
        data: Data, type: String, filename: String, slugPath: String
    ) {
        let asset = try await database.withConnection { connection in
            try await MediaAssetDatabaseQueries(
                context: .init(connection: connection)
            )
            .find(id: assetId)
        }
        return (
            try await MediaStorageData.download(
                from: storage,
                key: storageKeyShard.physicalKey(for: objectKey(for: asset))
            ),
            asset.contentType, "\(asset.name).\(asset.extension)",
            asset.slugPath
        )
    }

    public func readVariantFile(assetId: String, variantName: String)
        async throws -> (data: Data, type: String, filename: String)
    {
        let variant = try await database.withConnection { connection in
            let repo = MediaAssetNodeFileVariantDatabaseRepository(
                context: .init(connection: connection, idGenerator: idGenerator)
            )
            guard
                let value = try await repo.list(nodeId: assetId)
                    .first(where: { $0.name == variantName })
            else { throw RepositoryError.notFound }
            return value
        }
        return (
            try await MediaStorageData.download(
                from: storage,
                key: storageKeyShard.physicalKey(for: variant.objectKey)
            ),
            mediaType(for: variant.extension),
            "\(variant.name).\(variant.extension)"
        )
    }

    public func listAssociatedVariantFiles(assetId: String) async throws
        -> [AssociatedVariantFile]
    {
        try await database.withConnection { connection in
            let repo = MediaAssetNodeFileVariantDatabaseRepository(
                context: .init(connection: connection, idGenerator: idGenerator)
            )
            let variantDefinitions = Dictionary(
                uniqueKeysWithValues: try await MediaVariantDatabaseRepository(
                    context: .init(
                        connection: connection,
                        idGenerator: idGenerator
                    )
                )
                .list()
                .map { ($0.id, $0.key) }
            )
            guard
                try await MediaAssetNodeFileDatabaseRepository(
                    context: .init(
                        connection: connection,
                        idGenerator: idGenerator
                    )
                )
                .find(id: assetId) != nil
            else { throw RepositoryError.notFound }
            return try await repo.list(nodeId: assetId)
                .map {
                    .init(
                        assetId: assetId,
                        variantId: $0.variantId,
                        key: variantDefinitions[$0.variantId] ?? $0.name,
                        name: $0.name,
                        extension: $0.extension,
                        objectKey: $0.objectKey
                    )
                }
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
    switch `extension`.lowercased() {
    case "jpg", "jpeg": "image/jpeg"
    case "png": "image/png"
    case "gif": "image/gif"
    case "webp": "image/webp"
    case "pdf": "application/pdf"
    case "mp4": "video/mp4"
    default: "application/octet-stream"
    }
}
