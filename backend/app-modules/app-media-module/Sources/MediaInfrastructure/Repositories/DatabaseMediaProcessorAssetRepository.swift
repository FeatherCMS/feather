import MediaDomain
import FeatherDatabase

extension MediaProcessorAssetTable.Row {
    var asDomain: MediaProcessorAsset {
        .init(
            id: id,
            assetId: assetId,
            processorId: processorId,
            storageKey: storageKey,
            createdAt: createdAt
        )
    }
}

public struct DatabaseMediaProcessorAssetRepository:
    MediaProcessorAssetRepository
{
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: MediaProcessorAsset.New
    ) async throws -> MediaProcessorAsset {
        let row = try await MediaProcessorAssetTable(connection: connection)
            .create(
                row: .init(
                    id: model.id,
                    assetId: model.assetId,
                    processorId: model.processorId,
                    storageKey: model.storageKey
                )
            )
        return row.asDomain
    }

    public func find(
        assetId: String,
        processorId: String
    ) async throws -> MediaProcessorAsset? {
        try await MediaProcessorAssetTable(connection: connection)
            .find(assetId: assetId, processorId: processorId)?
            .asDomain
    }

    public func list(
        assetId: String
    ) async throws -> [MediaProcessorAsset] {
        try await MediaProcessorAssetTable(connection: connection)
            .list(assetId: assetId).map(\.asDomain)
    }

    public func deleteAll(
        assetId: String
    ) async throws {
        try await MediaProcessorAssetTable(connection: connection)
            .deleteAll(assetId: assetId)
    }
}
