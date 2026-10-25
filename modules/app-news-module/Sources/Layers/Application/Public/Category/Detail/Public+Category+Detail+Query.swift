public import FeatherApplication
import NewsModule

extension Public.Category.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func listPublicArticles(
                categoryID: String,
                page: Search.Page
            ) async throws -> [Public.Article.Item]

            func countPublicArticles(categoryID: String) async throws -> Int
        }
    }
}
