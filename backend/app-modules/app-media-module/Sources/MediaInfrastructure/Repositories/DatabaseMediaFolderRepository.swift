import FeatherDatabase
import MediaDomain

extension MediaFolderTable.Row {
    var asDomain: MediaFolder {
        .init(
            id: id,
            parentId: parentId,
            name: name,
            path: path,
            assetCount: assetCount,
            totalSizeBytes: totalSizeBytes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt
        )
    }
}

public struct DatabaseMediaFolderRepository: MediaFolderRepository {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: MediaFolder.New
    ) async throws -> MediaFolder {
        let row = try await MediaFolderTable(connection: connection)
            .create(
                row: .init(
                    id: model.id,
                    parentId: model.parentId,
                    name: model.name,
                    path: model.path,
                    assetCount: model.assetCount,
                    totalSizeBytes: model.totalSizeBytes
                )
            )
        return row.asDomain
    }

    public func update(
        _ model: MediaFolder
    ) async throws -> MediaFolder {
        let row = try await MediaFolderTable(connection: connection)
            .update(
                row: .init(
                    id: model.id,
                    parentId: model.parentId,
                    name: model.name,
                    path: model.path,
                    assetCount: model.assetCount,
                    totalSizeBytes: model.totalSizeBytes,
                    createdAt: model.createdAt,
                    updatedAt: model.updatedAt,
                    deletedAt: model.deletedAt
                )
            )
        return row.asDomain
    }

    public func find(
        id: String
    ) async throws -> MediaFolder? {
        try await MediaFolderTable(connection: connection).find(id: id)?
            .asDomain
    }

    public func find(
        path: String
    ) async throws -> MediaFolder? {
        try await MediaFolderTable(connection: connection).find(path: path)?
            .asDomain
    }

    public func list(
        parentId: String?
    ) async throws -> [MediaFolder] {
        try await MediaFolderTable(connection: connection)
            .list(parentId: parentId)
            .map(\.asDomain)
    }

    public func listDescendants(
        path: String
    ) async throws -> [MediaFolder] {
        try await MediaFolderTable(connection: connection)
            .listDescendants(path: path)
            .map(\.asDomain)
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        try await MediaFolderTable(connection: connection).delete(id: id)
    }
}
