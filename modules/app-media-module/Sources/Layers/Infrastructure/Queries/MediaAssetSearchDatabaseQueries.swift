import FeatherApplication
import FeatherInfrastructure
import MediaApplication

extension MediaAssetNodeTable.SearchRow {
    func asItem() throws -> MediaAssetSearchList.Item {
        switch kind {
        case "folder":
            guard let assetCount, let totalSizeBytes else {
                throw RepositoryError.notFound
            }
            return .folder(
                .init(
                    id: id,
                    parentId: parentId,
                    name: name,
                    slug: slug,
                    slugPath: slugPath,
                    assetCount: assetCount,
                    totalSizeBytes: totalSizeBytes,
                    createdAt: createdAt,
                    updatedAt: updatedAt
                )
            )
        case "file":
            guard objectKey != nil, let `extension`, let contentType,
                let sizeBytes, let status
            else { throw RepositoryError.notFound }
            return .asset(
                .init(
                    id: id,
                    folderId: parentId,
                    name: name,
                    slug: slug,
                    slugPath: slugPath,
                    url: mediaAssetPublicURL(
                        id: id,
                        slugPath: slugPath,
                        extension: `extension`
                    ),
                    extension: `extension`,
                    contentType: contentType,
                    sizeBytes: sizeBytes,
                    status: status,
                    title: title,
                    altText: altText,
                    createdAt: createdAt,
                    updatedAt: updatedAt
                )
            )
        default: throw RepositoryError.notFound
        }
    }
}

public struct MediaAssetSearchDatabaseQueries: MediaAssetSearchQueries {
    public let context: DatabaseQueryContext
    public init(context: DatabaseQueryContext) { self.context = context }

    private func pageSizeOffset(_ page: Search.Page) -> (size: Int, offset: Int)
    {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    private func orderBy(_ query: MediaAssetList.Query) -> String {
        let parts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .id: column = "id"
            case .name: column = "name"
            case .slugPath: column = "slug_path"
            case .extension: column = "extension"
            case .sizeBytes: column = "size_bytes"
            case .status: column = "status"
            case .title: column = "title"
            case .createdAt: column = "created_at"
            case .updatedAt: column = "updated_at"
            }
            return
                "CASE WHEN kind = 'file' THEN \(column) END \(rule.direction == .asc ? "ASC" : "DESC")"
        }
        return (["kind_rank ASC", "LOWER(name) ASC"] + parts + ["id ASC"])
            .joined(separator: ", ")
    }

    public func list(query: MediaAssetList.Query) async throws
        -> MediaAssetSearchList
    {
        let page = pageSizeOffset(query.page)
        let rows = try await MediaAssetNodeTable(connection: context.connection)
            .search(
                parentId: query.parentId,
                search: query.search,
                orderBy: orderBy(query),
                limit: page.size,
                offset: page.offset
            )
        return .init(items: try rows.map { try $0.asItem() })
    }

    public func count(query: MediaAssetList.Query) async throws -> Int {
        try await MediaAssetNodeTable(connection: context.connection)
            .count(parentId: query.parentId, search: query.search)
    }
}
