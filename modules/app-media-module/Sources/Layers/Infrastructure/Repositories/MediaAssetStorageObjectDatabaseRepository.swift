import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaDomain

extension MediaAssetStorageObjectTable.Row {
    var asDomain: MediaAssetStorageObject {
        .init(
            id: id,
            objectKey: objectKey,
            createdAt: createdAt,
            deletedAt: deletedAt
        )
    }
}

public struct MediaAssetStorageObjectDatabaseRepository:
    MediaAssetStorageObjectRepository
{
    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(_ model: MediaAssetStorageObject.New) async throws
        -> MediaAssetStorageObject
    {
        let row = try await MediaAssetStorageObjectTable(
            connection: context.connection
        )
        .create(
            row: .init(
                id: context.idGenerator.generate(),
                objectKey: model.objectKey
            )
        )
        return row.asDomain
    }

    public func insert(_ models: [MediaAssetStorageObject.New]) async throws
        -> [MediaAssetStorageObject]
    {
        guard !models.isEmpty else { return [] }
        let rows = models.map {
            MediaAssetStorageObjectTable.Row.Create(
                id: context.idGenerator.generate(),
                objectKey: $0.objectKey
            )
        }
        return try await MediaAssetStorageObjectTable(
            connection: context.connection
        )
        .create(rows: rows)
        .map(\.asDomain)
    }

    public func delete(ids: [String]) async throws -> [String] {
        try await MediaAssetStorageObjectTable(connection: context.connection)
            .delete(ids: ids)
    }
}
