import FeatherApplication
public import FeatherDomain
public import FeatherInfrastructure
public import MediaApplication
public import MediaModule

extension Asset.Node.Table.SearchRow {
    func asItem(
        objectKeyGenerator: any ObjectKeyGenerator =
            HierarchicalObjectKeyGenerator()
    )
        throws
        -> Asset.File.Search.Output.Item
    {
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
            guard let `extension`, let contentType,
                let sizeBytes, let status
            else { throw RepositoryError.notFound }
            return .asset(
                .init(
                    id: id,
                    folderId: parentId,
                    name: name,
                    slug: slug,
                    slugPath: slugPath,
                    url: try mediaAssetPublicURL(
                        id: id,
                        slugPath: slugPath,
                        filename: name,
                        extension: `extension`,
                        objectKeyGenerator: objectKeyGenerator
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

extension Asset.File.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext
        public let objectKeyGenerator: any ObjectKeyGenerator
        public init(
            context: DatabaseQueryContext,
            objectKeyGenerator: any ObjectKeyGenerator =
                HierarchicalObjectKeyGenerator()
        ) {
            self.context = context
            self.objectKeyGenerator = objectKeyGenerator
        }

        private func orderBy(_ query: Asset.File.Search.Input.Query) -> String {
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

        public func search(query: Asset.File.Search.Input.Query) async throws
            -> Asset.File.Search.Output
        {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let rows = try await Asset.Node
                .Table(
                    connection: context.connection,
                    context: DatabaseTransactionContext(
                        platform: context.platform,
                        connection: context.connection,
                        idGenerator: context.idGenerator
                    )
                )
                .search(
                    parentId: query.parentId,
                    search: query.search,
                    orderBy: orderBy(query),
                    limit: page.size,
                    offset: offset
                )
            let items = try rows.map {
                try $0.asItem(objectKeyGenerator: objectKeyGenerator)
            }
            let total = try await Asset.Node
                .Table(
                    connection: context.connection,
                    context: DatabaseTransactionContext(
                        platform: context.platform,
                        connection: context.connection,
                        idGenerator: context.idGenerator
                    )
                )
                .count(parentId: query.parentId, search: query.search)
            return .init(items: items, total: total)
        }
    }
}
