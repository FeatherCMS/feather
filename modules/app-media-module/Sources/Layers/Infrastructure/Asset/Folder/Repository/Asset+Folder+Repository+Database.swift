import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import MediaDomain
public import MediaModule

extension Asset.Folder.Table.Row {
    var asDomain: Asset.Folder.Model {
        .init(
            id: id,
            parentId: parentId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            assetCount: assetCount,
            totalSizeBytes: totalSizeBytes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt
        )
    }
}

extension Asset.Folder.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(_ model: Asset.Folder.Model.New) async throws
            -> Asset.Folder.Model
        {
            let row = try await Asset.Folder
                .Table(
                    connection: context.connection
                )
                .create(
                    row: .init(
                        id: context.idGenerator.generate(),
                        parentId: model.parentId,
                        name: model.name,
                        slug: model.slug,
                        slugPath: model.slugPath,
                        assetCount: model.assetCount,
                        totalSizeBytes: model.totalSizeBytes
                    )
                )
            return row.asDomain
        }

        public func update(_ model: Asset.Folder.Model) async throws
            -> Asset.Folder.Model
        {
            let row = try await Asset.Folder
                .Table(
                    connection: context.connection
                )
                .update(
                    row: .init(
                        id: model.id,
                        parentId: model.parentId,
                        name: model.name,
                        slug: model.slug,
                        slugPath: model.slugPath,
                        assetCount: model.assetCount,
                        totalSizeBytes: model.totalSizeBytes,
                        createdAt: model.createdAt,
                        updatedAt: model.updatedAt,
                        deletedAt: model.deletedAt
                    )
                )
            return row.asDomain
        }

        public func find(id: String) async throws -> Asset.Folder.Model? {
            try await Asset.Folder.Table(connection: context.connection)
                .find(id: id)?
                .asDomain
        }

        public func find(slugPath: String) async throws -> Asset.Folder.Model? {
            try await Asset.Folder.Table(connection: context.connection)
                .find(slugPath: slugPath)?
                .asDomain
        }

        public func list(parentId: String?) async throws -> [Asset.Folder.Model]
        {
            try await Asset.Folder.Table(connection: context.connection)
                .list(parentId: parentId)
                .map(\.asDomain)
        }

        public func listDescendants(slugPath: String) async throws
            -> [Asset.Folder.Model]
        {
            try await Asset.Folder.Table(connection: context.connection)
                .listDescendants(slugPath: slugPath)
                .map(\.asDomain)
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await Asset.Folder.Table(connection: context.connection)
                .delete(ids: ids)
        }
    }
}
