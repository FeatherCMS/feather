import FeatherDatabase
import Infrastructure
import MediaApplication

extension MediaFolderTable.Row {
    var asDetail: MediaFolderDetail {
        .init(
            id: id,
            parentId: parentId,
            name: name,
            path: path,
            assetCount: assetCount,
            totalSizeBytes: totalSizeBytes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asListItem: MediaFolderList.Item {
        .init(
            id: id,
            parentId: parentId,
            name: name,
            path: path,
            assetCount: assetCount,
            totalSizeBytes: totalSizeBytes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseMediaFolderQueries: MediaFolderQueries {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func find(
        id: String
    ) async throws -> MediaFolderDetail {
        guard
            let row = try await MediaFolderTable(connection: connection)
                .find(
                    id: id
                )
        else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func list(
        query: MediaFolderList.Query
    ) async throws -> MediaFolderList {
        let rows = try await MediaFolderTable(connection: connection)
            .list(
                parentId: query.parentId
            )
        return .init(items: rows.map(\.asListItem))
    }
}
