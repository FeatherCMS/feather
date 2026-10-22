import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import MediaDomain
public import MediaModule

extension Asset.File.Table.Row {
    var asDomain: Asset.File.Model {
        .init(
            id: id,
            folderId: folderId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            storageObjectId: storageObjectId,
            extension: `extension`,
            contentType: contentType,
            sizeBytes: sizeBytes,
            status: .init(rawValue: status) ?? .uploaded,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt
        )
    }
}

extension Asset.File.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func prepareStorageIdentity() -> Asset.File.StorageIdentity {
            .init(nodeId: context.idGenerator.generate())
        }

        public func insert(
            _ model: Asset.File.Model.New,
            storageIdentity: Asset.File.StorageIdentity
        ) async throws -> Asset.File.Model {
            let row = try await Asset.File
                .Table(
                    connection: context.connection
                )
                .create(
                    row: .init(
                        id: storageIdentity.nodeId,
                        folderId: model.folderId,
                        name: model.name,
                        slug: model.slug,
                        slugPath: model.slugPath,
                        storageObjectId: model.storageObjectId,
                        extension: model.extension,
                        contentType: model.contentType,
                        sizeBytes: model.sizeBytes,
                        status: model.status.rawValue,
                        title: model.title,
                        altText: model.altText
                    )
                )
            return row.asDomain
        }

        public func update(_ model: Asset.File.Model) async throws
            -> Asset.File.Model
        {
            let row = try await Asset.File
                .Table(
                    connection: context.connection
                )
                .update(
                    row: .init(
                        id: model.id,
                        folderId: model.folderId,
                        name: model.name,
                        slug: model.slug,
                        slugPath: model.slugPath,
                        storageObjectId: model.storageObjectId,
                        extension: model.extension,
                        contentType: model.contentType,
                        sizeBytes: model.sizeBytes,
                        status: model.status.rawValue,
                        title: model.title,
                        altText: model.altText,
                        createdAt: model.createdAt,
                        updatedAt: model.updatedAt,
                        deletedAt: model.deletedAt
                    )
                )
            return row.asDomain
        }

        public func updateStatus(
            id: String,
            status: Asset.File.Model.Status
        ) async throws {
            try await Asset.File.Table(connection: context.connection)
                .updateStatus(id: id, status: status.rawValue)
        }

        public func find(id: String) async throws -> Asset.File.Model? {
            try await Asset.File.Table(connection: context.connection)
                .find(id: id)?
                .asDomain
        }

        public func find(slugPath: String) async throws -> Asset.File.Model? {
            try await Asset.File.Table(connection: context.connection)
                .find(slugPath: slugPath)?
                .asDomain
        }

        public func list(folderIds: [String]) async throws -> [Asset.File.Model]
        {
            try await Asset.File.Table(connection: context.connection)
                .list(folderIds: folderIds)
                .map(\.asDomain)
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await Asset.File.Table(connection: context.connection)
                .delete(ids: ids)
        }
    }
}
