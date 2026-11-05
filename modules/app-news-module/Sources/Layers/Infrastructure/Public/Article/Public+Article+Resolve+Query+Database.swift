import FeatherDBAL
public import FeatherInfrastructure
public import NewsApplication
import NewsDomain
import NewsModule

extension Public.Article.Resolve.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func resolve(ids: [String]) async throws -> Output {
            guard !ids.isEmpty else { return .init(items: []) }
            let rows = try await DatabaseAccessLayer<Article.Table>(
                context: context
            )
            .select { $0.where(\.id, in: ids) }
            var itemsByID: [String: Public.Article.Item] = [:]
            for row in rows {
                let item = Public.Article.Item(
                    id: row.id,
                    title: row.title,
                    excerpt: row.excerpt,
                    content: row.content,
                    imageAssetId: row.imageAssetId,
                    createdAt: row.createdAt,
                    updatedAt: row.updatedAt
                )
                precondition(itemsByID.updateValue(item, forKey: row.id) == nil)
            }
            return .init(items: ids.compactMap { itemsByID[$0] })
        }
    }
}
