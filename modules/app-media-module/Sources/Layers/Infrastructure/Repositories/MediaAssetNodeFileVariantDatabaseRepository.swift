import FeatherDomain
public import FeatherInfrastructure
public import MediaDomain

extension MediaAssetVariantTable.Row {
    var asDomain: MediaAssetNodeFileVariant {
        .init(
            id: id,
            assetNodeFileId: assetNodeFileId,
            variantId: variantId,
            variantProcessorId: variantProcessorId,
            storageObjectId: storageObjectId,
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
                assetNodeFileId: model.assetNodeFileId,
                variantId: model.variantId,
                variantProcessorId: model.variantProcessorId,
                storageObjectId: model.storageObjectId
            )
        )
        return row.asDomain
    }

    public func insert(_ models: [MediaAssetNodeFileVariant.New]) async throws {
        guard !models.isEmpty else { return }
        let rows = models.map {
            MediaAssetVariantTable.Row.Create(
                id: context.idGenerator.generate(),
                assetNodeFileId: $0.assetNodeFileId,
                variantId: $0.variantId,
                variantProcessorId: $0.variantProcessorId,
                storageObjectId: $0.storageObjectId
            )
        }
        try await MediaAssetVariantTable(connection: context.connection)
            .create(rows: rows)
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

    public func list(nodeIds: [String]) async throws
        -> [MediaAssetNodeFileVariant]
    {
        try await MediaAssetVariantTable(connection: context.connection)
            .list(nodeIds: nodeIds)
            .map(\.asDomain)
    }

    public func deleteAll(nodeId: String) async throws {
        try await MediaAssetVariantTable(connection: context.connection)
            .deleteAll(nodeId: nodeId)
    }

    public func deleteAll(nodeIds: [String]) async throws {
        try await MediaAssetVariantTable(connection: context.connection)
            .deleteAll(nodeIds: nodeIds)
    }
}
