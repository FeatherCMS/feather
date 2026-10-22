import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import MediaDomain
public import MediaModule

extension StorageObject.Table.Row {
    var asDomain: StorageObject.Model {
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

extension StorageObject.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(_ model: StorageObject.Model.New) async throws
            -> StorageObject.Model
        {
            let row =
                try await StorageObject.Table(
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

        public func insert(_ models: [StorageObject.Model.New]) async throws
            -> [StorageObject.Model]
        {
            let rows = models.map {
                StorageObject.Table.Row.Create(
                    id: context.idGenerator.generate(),
                    key: $0.key,
                    extension: $0.extension,
                    contentType: $0.contentType,
                    sizeInBytes: $0.sizeInBytes
                )
            }
            return
                try await StorageObject.Table(
                    connection: context.connection
                )
                .create(rows: rows)
                .map(\.asDomain)
        }

        public func find(storageObjectId: String) async throws
            -> StorageObject.Model?
        {
            try await StorageObject
                .Table(
                    connection: context.connection
                )
                .find(storageObjectId: storageObjectId)?
                .asDomain
        }

        public func list(assetNodeFileIds: [String]) async throws
            -> [StorageObject.Model]
        {
            try await StorageObject.Table(
                connection: context.connection
            )
            .list(assetNodeFileIds: assetNodeFileIds)
            .map(\.asDomain)
        }
    }
}
