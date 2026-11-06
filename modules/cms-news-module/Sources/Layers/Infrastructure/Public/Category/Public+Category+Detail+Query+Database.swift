public import FeatherApplication
public import FeatherInfrastructure
public import NewsApplication
import NewsDomain
import NewsModule

extension Public.Category.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func listPublicArticles(
            categoryID: String,
            page: Search.Page
        ) async throws -> [Public.Article.Item] {
            let page = page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let queries = Public.Article.AccessLayer(
                connection: context.connection
            )
            let orderBy = queries.defaultPublicOrderByArticle + ", id ASC"
            let rows = try await queries.listPublic(
                search: nil,
                categoryID: categoryID,
                orderBy: orderBy,
                limit: page.size,
                offset: offset
            )
            return rows.map {
                .init(
                    id: $0.id,
                    title: $0.title,
                    excerpt: $0.excerpt,
                    content: $0.content,
                    imageAssetId: $0.imageAssetId,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt
                )
            }
        }

        public func countPublicArticles(categoryID: String) async throws -> Int
        {
            try await Public.Article.AccessLayer(connection: context.connection)
                .countPublic(search: nil, categoryID: categoryID)
        }
    }
}
