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
        let storagePrefix = try storageContext.objectKeyGenerator.generate(
            from: asset.id
        )
        let sequence = try await storageContext.storage.download(
            key: "\(storagePrefix)/original.\(asset.extension)",
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
        let storagePrefix = try storageContext.objectKeyGenerator.generate(
            from: variant.nodeId
        )
        let objectKey =
            "\(storagePrefix)/variants/\(variant.name).\(variant.extension)"
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
                let asset = try await MediaAssetNodeFileDatabaseRepository(
                    context: .init(
                        connection: connection,
                        idGenerator: idGenerator
                    )
                )
                .find(id: assetId)
            else { throw RepositoryError.notFound }
            return try await repo.list(nodeId: assetId)
                .map {
                    .init(
                        assetId: assetId,
                        slugPath: asset.slugPath,
                        filename: asset.name,
                        variantId: $0.variantId,
                        key: variantDefinitions[$0.variantId] ?? $0.name,
                        name: $0.name,
                        url: try mediaVariantPublicURL(
                            assetId: assetId,
                            slugPath: asset.slugPath,
                            filename: asset.name,
                            variantKey: variantDefinitions[$0.variantId]
                                ?? $0.name,
                            extension: $0.extension,
                            objectKeyGenerator: storageContext
                                .objectKeyGenerator
                        ),
                        extension: $0.extension,
                        objectKey: $0.objectKey
                    )
                }
        }
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
