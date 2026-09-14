import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure
import MediaApplication

extension MediaAssetSearchTable.Row {
    func asItem() throws -> MediaAssetSearchList.Item {
        switch kind {
        case "folder":
            guard
                let path,
                let assetCount,
                let totalSizeBytes
            else {
                throw RepositoryError.notFound
            }
            return .folder(
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
            )
        case "file":
            guard
                let storageKey,
                let baseName,
                let type,
                let sizeBytes,
                let status
            else {
                throw RepositoryError.notFound
            }
            return .asset(
                .init(
                    id: id,
                    folderId: parentId,
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
            )
        default:
            throw RepositoryError.notFound
        }
    }
}

public struct MediaAssetSearchDatabaseQueries: MediaAssetSearchQueries {
    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
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
            return
                "CASE WHEN kind = 'file' THEN \(column) END \(sortDirectionSQL(rule.direction))"
        }
        return (
            [
                "kind_rank ASC",
            "CASE WHEN kind = 'folder' THEN LOWER(name) END ASC",
            ] + sortParts + ["id ASC"]
        )
        .joined(separator: ", ")
    }

    public func list(
        query: MediaAssetList.Query
    ) async throws -> MediaAssetSearchList {
        let page = pageSizeOffset(query.page)
        let rows = try await MediaAssetSearchTable(
            connection: context.connection
        )
        .list(
            parentId: query.parentId,
            search: query.search,
            orderBy: orderBy(query),
            limit: page.size,
            offset: page.offset
        )
        return .init(items: try rows.map { try $0.asItem() })
    }

    public func count(
        query: MediaAssetList.Query
    ) async throws -> Int {
        try await MediaAssetSearchTable(connection: context.connection)
            .count(parentId: query.parentId, search: query.search)
    }
}
