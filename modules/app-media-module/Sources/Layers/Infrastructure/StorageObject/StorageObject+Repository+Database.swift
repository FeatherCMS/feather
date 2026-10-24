public import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import MediaDomain
public import MediaModule

extension StorageObject.Table.Detail {
    var asDomain: StorageObject.Model {
        .init(id: id, key: key, extension: fileExtension, contentType: contentType, sizeInBytes: sizeInBytes, createdAt: createdAt)
    }
}

extension StorageObject.Table.List {
    var asDomain: StorageObject.Model {
        .init(id: id, key: key, extension: fileExtension, contentType: contentType, sizeInBytes: sizeInBytes, createdAt: createdAt)
    }
}

extension StorageObject.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext
        private let accessLayer: DatabaseAccessLayer<StorageObject.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func insert(_ model: StorageObject.Model.New) async throws -> StorageObject.Model {
            let row = StorageObject.Table.Insert(
                id: context.idGenerator.generate(),
                key: model.key,
                fileExtension: model.extension,
                contentType: model.contentType,
                sizeInBytes: model.sizeInBytes
            )
            try await accessLayer.insert(row)
            guard let saved = try await accessLayer.selectFirst(by: \.id, equals: row.id) else {
                throw RepositoryError.notFound
            }
            return saved.asDomain
        }

        public func insert(_ models: [StorageObject.Model.New]) async throws -> [StorageObject.Model] {
            let rows = models.map {
                StorageObject.Table.Insert(
                    id: context.idGenerator.generate(),
                    key: $0.key,
                    fileExtension: $0.extension,
                    contentType: $0.contentType,
                    sizeInBytes: $0.sizeInBytes
                )
            }
            try await accessLayer.insert(rows)
            let ids = rows.map(\.id)
            return try await accessLayer.select { $0.where(\.id, in: ids) }
                .map(\.asDomain)
        }

        public func find(storageObjectId: String) async throws -> StorageObject.Model? {
            try await accessLayer.selectFirst(by: \.id, equals: storageObjectId).map(\.asDomain)
        }

        public func list(assetNodeFileIds: [String]) async throws -> [StorageObject.Model] {
            try await StorageObjectAssociatedQuery(connection: context.connection)
                .list(assetNodeFileIds: assetNodeFileIds)
                .map(\.asDomain)
        }
    }
}
