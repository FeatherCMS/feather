import FeatherApplication
public import FeatherInfrastructure
public import NewsApplication
import NewsDomain
import NewsModule

extension Public.Article.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func listPublic(
            query: NewsApplication.Public.Article.List.Input.Query
        ) async throws -> Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let queries = ArticleQueries(connection: context.connection)
            let rows = try await queries.listPublic(
                search: nil,
                categoryID: query.categoryID,
                orderBy: queries.orderByPublicArticle(query),
                limit: page.size,
                offset: offset
            )
            return .init(
                items: rows.map {
                    Public.Article.Item(
                        id: $0.id,
                        title: $0.title,
                        excerpt: $0.excerpt,
                        content: $0.content,
                        imageAssetId: $0.imageAssetId,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                }
            )
        }

        public func countPublic(categoryID: String?) async throws -> Int {
            try await ArticleQueries(connection: context.connection)
                .countPublic(search: nil, categoryID: categoryID)
        }
    }
}
