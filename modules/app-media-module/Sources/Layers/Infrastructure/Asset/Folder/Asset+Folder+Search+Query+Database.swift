import FeatherApplication
public import FeatherInfrastructure
public import MediaApplication
public import MediaModule

extension Asset.Folder.Table.Row {
    var asSearchItem: Asset.Folder.Search.Output.Item {
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
    }
}

extension Asset.Folder.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        private func orderBy(_ query: Asset.Folder.Search.Input.Query) -> String
        {
            let parts = query.sort.map { rule -> String in
                let column: String
                switch rule.field {
                case .id: column = "n.id"
                case .name: column = "n.name"
                case .path: column = "slug_path"
                case .assetCount: column = "asset_count"
                case .totalSizeBytes: column = "f.total_size_bytes"
                case .createdAt: column = "n.created_at"
                case .updatedAt: column = "n.updated_at"
                }
                let direction = rule.direction == .asc ? "ASC" : "DESC"
                return "\(column) \(direction)"
            }
            return (["LOWER(n.name) ASC"] + parts + ["n.id ASC"])
                .joined(separator: ", ")
        }

        public func search(query: Asset.Folder.Search.Input.Query) async throws
            -> Asset.Folder.Search.Output
        {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let table = Asset.Folder.Table(
                connection: context.connection,
                context: DatabaseTransactionContext(
                    platform: context.platform,
                    connection: context.connection,
                    idGenerator: context.idGenerator
                )
            )
            let rows = try await table.search(
                parentId: query.parentId,
                orderBy: orderBy(query),
                limit: page.size,
                offset: offset
            )
            let total = try await table.count(parentId: query.parentId)
            return .init(items: rows.map(\.asSearchItem), total: total)
        }
    }
}
