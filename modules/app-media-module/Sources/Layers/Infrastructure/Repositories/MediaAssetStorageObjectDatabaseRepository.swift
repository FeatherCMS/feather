import FeatherDomain
public import FeatherInfrastructure
public import MediaDomain

extension MediaAssetStorageObjectTable.Row {
    var asDomain: MediaAssetStorageObject {
        .init(
            id: id,
            key: key,
            extension: `extension`,
            contentType: contentType,
            sizeInBytes: sizeInBytes,
            createdAt: createdAt
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
                key: model.key,
                extension: model.extension,
                contentType: model.contentType,
                sizeInBytes: model.sizeInBytes
            )
        )
        return row.asDomain
    }

    public func insert(_ models: [MediaAssetStorageObject.New]) async throws
        -> [MediaAssetStorageObject]
    {
        let rows = models.map {
            MediaAssetStorageObjectTable.Row.Create(
                id: context.idGenerator.generate(),
                key: $0.key,
                extension: $0.extension,
                contentType: $0.contentType,
                sizeInBytes: $0.sizeInBytes
            )
        }
        return try await MediaAssetStorageObjectTable(
            connection: context.connection
        )
        .create(rows: rows)
        .map(\.asDomain)
    }

    public func find(storageObjectId: String) async throws
        -> MediaAssetStorageObject?
    {
        try await MediaAssetStorageObjectTable(connection: context.connection)
            .find(storageObjectId: storageObjectId)?
            .asDomain
    }

    public func list(assetNodeFileIds: [String]) async throws
        -> [MediaAssetStorageObject]
    {
        try await MediaAssetStorageObjectTable(connection: context.connection)
            .list(assetNodeFileIds: assetNodeFileIds)
            .map(\.asDomain)
    }
}
