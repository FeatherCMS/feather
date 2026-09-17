import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaDomain

extension MediaAssetVariantTable.Row {
    var asDomain: MediaAssetNodeFileVariant {
        .init(
            id: id,
            nodeId: nodeId,
            variantId: variantId,
            variantProcessorId: variantProcessorId,
            name: name,
            storageObjectId: storageObjectId,
            objectKey: objectKey,
            extension: `extension`,
            createdAt: createdAt
        )
    }
}

public struct MediaAssetNodeFileVariantDatabaseRepository:
    MediaAssetNodeFileVariantRepository
{
    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(_ model: MediaAssetNodeFileVariant.New) async throws
        -> MediaAssetNodeFileVariant
    {
        let row = try await MediaAssetVariantTable(
            connection: context.connection
        )
        .create(
            row: .init(
                id: context.idGenerator.generate(),
                nodeId: model.nodeId,
                variantId: model.variantId,
                variantProcessorId: model.variantProcessorId,
                name: model.name,
                storageObjectId: model.storageObjectId,
                extension: model.extension
            )
        )
        return row.asDomain
    }

    public func find(nodeId: String, variantId: String) async throws
        -> MediaAssetNodeFileVariant?
    {
        try await MediaAssetVariantTable(connection: context.connection)
            .find(nodeId: nodeId, variantId: variantId)?
            .asDomain
    }

    public func list(nodeId: String) async throws -> [MediaAssetNodeFileVariant]
    {
        try await MediaAssetVariantTable(connection: context.connection)
            .list(nodeId: nodeId)
            .map(\.asDomain)
    }

    public func deleteAll(nodeId: String) async throws {
        try await MediaAssetVariantTable(connection: context.connection)
            .deleteAll(nodeId: nodeId)
    }
}
