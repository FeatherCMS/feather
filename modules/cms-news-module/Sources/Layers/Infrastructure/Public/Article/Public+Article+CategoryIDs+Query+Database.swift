public import FeatherInfrastructure
public import NewsApplication
import NewsDomain
import NewsModule

extension Public.Article.CategoryIDs.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func categoryIDs(for articleIDs: [String]) async throws
            -> [String: [String]]
        {
            try await ArticleCategory.Table.listCategoryIDs(
                context: context,
                articleIDs: articleIDs
            )
        }
    }
}
