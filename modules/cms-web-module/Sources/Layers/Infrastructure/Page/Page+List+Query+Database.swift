import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Page.Table.List {
    var asListItem: Page.List.Output.Item {
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

extension Page.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list() async throws -> Page.List.Output {
            let rows = try await DatabaseAccessLayer<Page.Table>(
                context: context
            )
            .select {
                $0.order(by: \.id, .ascending).limit(10_000)
            }
            return .init(items: rows.map(\.asListItem))
        }
    }
}
