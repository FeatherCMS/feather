import FeatherApplication
public import FeatherContracts
public import FeatherDatabase
public import FeatherDomain
import FeatherInfrastructure
import FeatherStorage
public import Foundation
public import MediaApplication
public import MediaDomain
import MediaInfrastructure
import NIOCore

public struct UseCases: Sendable {
    public struct AssociatedVariantFile: Sendable {
        public let assetId: String
        public let slugPath: String
        public let filename: String
        public let variantId: String
        public let key: String
        public let name: String
        public let url: String
        public let `extension`: String
        public let objectKey: String
    }

    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let storageContext: StorageContext
    let variantQueue: any MediaVariantQueue
    let authorizer: any Authorizer

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        storageContext: StorageContext,
        authorizer: any Authorizer,
        variantQueue: any MediaVariantQueue
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.storageContext = storageContext
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
            return try await repo.update(value)
                .asDetail(
                    objectKeyGenerator: storageContext.objectKeyGenerator
                )
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
                context: .init(connection: connection),
                objectKeyGenerator: storageContext.objectKeyGenerator
            )
            .find(id: id)
        }
    }

    public func readOriginalAssetFile(assetId: String) async throws -> (
        data: Data, type: String, filename: String, slugPath: String
    ) {
        let asset = try await database.withConnection { connection in
            try await MediaAssetDatabaseQueries(
                context: .init(connection: connection),
                objectKeyGenerator: storageContext.objectKeyGenerator
            )
            .find(id: assetId)
        }
        let sequence = try await storageContext.storage.download(
            key: try MediaAssetStorageObject.storageKey(
                assetID: asset.id,
                key: "original",
                extension: asset.extension,
                objectKeyGenerator: storageContext.objectKeyGenerator
            ),
            range: nil
        )
        var data = Data()
        for try await buffer in sequence {
            data.append(contentsOf: buffer.readableBytesView)
        }
        return (
            data,
            asset.contentType, "\(asset.name).\(asset.extension)",
            asset.slugPath
        )
    }

    public func readVariantFile(assetId: String, variantName: String)
        async throws -> (data: Data, type: String, filename: String)
    {
        let stored = try await database.withConnection { connection in
            let repo = MediaAssetNodeFileVariantDatabaseRepository(
                context: .init(connection: connection, idGenerator: idGenerator)
            )
            let definitions = try await MediaVariantDatabaseRepository(
                context: .init(connection: connection, idGenerator: idGenerator)
            )
            .list()
            guard
                let definition = definitions.first(where: {
                    $0.key == variantName
                }),
                let value = try await repo.list(nodeId: assetId)
                    .first(where: { $0.variantId == definition.id })
            else { throw RepositoryError.notFound }
            let objectRepository = MediaAssetStorageObjectDatabaseRepository(
                context: .init(connection: connection, idGenerator: idGenerator)
            )
            guard
                let object = try await objectRepository.find(
                    storageObjectId: value.storageObjectId
                )
            else { throw RepositoryError.notFound }
            return (value, definition, object)
        }
        let objectKey = try MediaAssetStorageObject.storageKey(
            assetID: assetId,
            key: stored.2.key,
            extension: stored.2.extension,
            objectKeyGenerator: storageContext.objectKeyGenerator
        )
        let sequence = try await storageContext.storage.download(
            key: objectKey,
            range: nil
        )
        var data = Data()
        for try await buffer in sequence {
            data.append(contentsOf: buffer.readableBytesView)
        }
        return (
            data,
            stored.2.contentType,
            "\(stored.1.key).\(stored.2.extension)"
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
                .map { ($0.id, $0) }
            )
            guard
                let asset = try await MediaAssetNodeFileDatabaseRepository(
                    context: .init(
                        connection: connection,
                        idGenerator: idGenerator
                    )
                )
                .find(id: assetId)
            else { throw RepositoryError.notFound }
            let objects = try await MediaAssetStorageObjectDatabaseRepository(
                context: .init(connection: connection, idGenerator: idGenerator)
            )
            .list(assetNodeFileIds: [assetId])
            let objectsByID = Dictionary(
                uniqueKeysWithValues: objects.map { ($0.id, $0) }
            )
            return try await repo.list(nodeId: assetId)
                .compactMap { relation -> AssociatedVariantFile? in
                    guard
                        let definition = variantDefinitions[relation.variantId],
                        let object = objectsByID[relation.storageObjectId]
                    else { return nil }
                    return AssociatedVariantFile(
                        assetId: assetId,
                        slugPath: asset.slugPath,
                        filename: asset.name,
                        variantId: relation.variantId,
                        key: definition.key,
                        name: definition.name,
                        url: try mediaVariantPublicURL(
                            assetId: assetId,
                            slugPath: asset.slugPath,
                            filename: asset.name,
                            variantKey: definition.key,
                            extension: object.extension,
                            objectKeyGenerator: storageContext
                                .objectKeyGenerator
                        ),
                        extension: object.extension,
                        objectKey:
                            try MediaAssetStorageObject.storageKey(
                                assetID: assetId,
                                key: object.key,
                                extension: object.extension,
                                objectKeyGenerator: storageContext
                                    .objectKeyGenerator
                            )
                    )
                }
        }
    }

}
