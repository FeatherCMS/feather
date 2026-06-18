import Application
import FeatherDatabase
import Infrastructure
import MediaApplication

extension MediaAssetTable.Row {
    var asDetail: MediaAssetDetail {
        .init(
            id: id,
            folderId: folderId,
            storageKey: storageKey,
            baseName: baseName,
            type: type,
            sizeBytes: sizeBytes,
            status: status,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt
        )
    }

    var asListItem: MediaAssetList.Item {
        .init(
            id: id,
            folderId: folderId,
            storageKey: storageKey,
            baseName: baseName,
            type: type,
            sizeBytes: sizeBytes,
            status: status,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseMediaAssetQueries: MediaAssetQueries {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    private func pageSizeOffset(
        _ page: Search.Page
    ) -> (size: Int, offset: Int) {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    private func sortDirectionSQL(
        _ direction: Search.SortDirection
    ) -> String {
        switch direction {
        case .asc: "ASC"
        case .desc: "DESC"
        }
    }

    private func orderBy(
        _ query: MediaAssetList.Query
    ) -> String {
        let sortParts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .id: column = "id"
            case .storageKey: column = "storage_key"
            case .type: column = "type"
            case .sizeBytes: column = "size_bytes"
            case .status: column = "status"
            case .title: column = "title"
            case .createdAt: column = "created_at"
            case .updatedAt: column = "updated_at"
            }
            return "\(column) \(sortDirectionSQL(rule.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> MediaAssetDetail {
        let table = MediaAssetTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func findByStorageKey(
        _ storageKey: String
    ) async throws -> MediaAssetDetail? {
        try await MediaAssetTable(connection: connection)
            .find(storageKey: storageKey)?
            .asDetail
    }

    public func list(
        query: MediaAssetList.Query
    ) async throws -> MediaAssetList {
        let page = pageSizeOffset(query.page)
        let rows = try await MediaAssetTable(connection: connection)
            .list(
                parentId: query.parentId,
                search: query.search,
                orderBy: orderBy(query),
                limit: page.size,
                offset: page.offset
            )
        return .init(items: rows.map { $0.asListItem })
    }

    public func count(
        query: MediaAssetList.Query
    ) async throws -> Int {
        try await MediaAssetTable(connection: connection)
            .count(parentId: query.parentId, search: query.search)
    }
}
