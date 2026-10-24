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
            let itemsByID = Dictionary(
                uniqueKeysWithValues: rows.map {
                    (
                        $0.id,
                        Public.Article.Item(
                            id: $0.id,
                            title: $0.title,
                            excerpt: $0.excerpt,
                            content: $0.content,
                            imageAssetId: $0.imageAssetId,
                            createdAt: $0.createdAt,
                            updatedAt: $0.updatedAt
                        )
                    )
                }
            )
            return .init(items: ids.compactMap { itemsByID[$0] })
        }
    }
}
