import FeatherDBAL
public import FeatherInfrastructure
public import NewsApplication
public import NewsModule

extension Category.Table.List {
    var asListItem: Category.List.Output.Item {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            imageAssetId: imageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Category.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list() async throws -> Category.List.Output {
            let accessLayer = DatabaseAccessLayer<Category.Table>(
                context: context
            )

            let items =
                try await accessLayer
                .select(as: Category.Table.List.self) { initial in
                    initial.order(by: [.init(by: \.id, .ascending)])
                }
                .map(\.asListItem)

            return .init(items: items)
        }
    }
}
