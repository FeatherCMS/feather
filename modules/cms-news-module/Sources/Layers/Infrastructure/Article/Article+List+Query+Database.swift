import FeatherDBAL
public import FeatherInfrastructure
public import NewsApplication
import NewsDomain
public import NewsModule

extension Article.Table.List {
    var asQueryListItem: Article.List.Output.Item {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Article.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list() async throws -> Article.List.Output {
            let items = try await DatabaseAccessLayer<Article.Table>(
                context: context
            )
            .select(as: Article.Table.List.self) { initial in
                initial.order(by: [.init(by: \.id, .ascending)])
            }
            .map(\.asQueryListItem)
            return .init(items: items)
        }
    }
}
