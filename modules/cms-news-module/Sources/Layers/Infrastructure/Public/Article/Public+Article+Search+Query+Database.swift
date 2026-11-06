import FeatherApplication
public import FeatherInfrastructure
public import NewsApplication
import NewsDomain
import NewsModule

extension Public.Article.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func searchPublic(
            query: NewsApplication.Public.Article.Search.Input.Query
        ) async throws -> Output {
            let page =
                Search.Page(size: query.pageSize, number: query.pageNumber)
                .normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let queries = Public.Article.AccessLayer(
                connection: context.connection
            )
            let rows =
                try await queries
                .listPublic(
                    search: query.search,
                    categoryID: nil,
                    orderBy: queries.defaultPublicOrderByArticle + ", id ASC",
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

        public func countPublic(search: String?) async throws -> Int {
            try await Public.Article.AccessLayer(connection: context.connection)
                .countPublic(search: search)
        }
    }
}
