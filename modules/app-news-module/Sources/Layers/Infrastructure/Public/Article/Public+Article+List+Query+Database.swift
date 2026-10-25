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

        public func listPublic(limit: Int) async throws -> Output {
            let queries = Public.Article.AccessLayer(
                connection: context.connection
            )
            let rows = try await queries.listPublic(
                search: nil,
                categoryID: nil,
                orderBy: queries.orderByPublicArticle(),
                limit: limit,
                offset: 0
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
    }
}
