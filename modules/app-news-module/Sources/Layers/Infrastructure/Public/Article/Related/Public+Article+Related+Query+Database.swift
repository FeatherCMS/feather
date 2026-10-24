public import FeatherInfrastructure
public import NewsApplication
import NewsDomain
import NewsModule

extension Public.Article.Related.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func listPublicRelated(
            categoryIDs: [String],
            excludingArticleID: String,
            limit: Int
        ) async throws -> Output {
            let categoryIDs = Array(Set(categoryIDs)).filter { !$0.isEmpty }
                .sorted()
            guard !categoryIDs.isEmpty, limit > 0 else {
                return .init(items: [])
            }
            let queries = ArticleQueries(connection: context.connection)
            let rows =
                try await queries
                .listPublicRelated(
                    categoryIDs: categoryIDs,
                    excludingArticleID: excludingArticleID,
                    limit: limit,
                    orderBy: queries.defaultPublicOrderByArticle + ", id ASC"
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
