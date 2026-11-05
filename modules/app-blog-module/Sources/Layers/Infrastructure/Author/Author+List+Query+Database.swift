public import BlogApplication
public import BlogModule
import FeatherDBAL
public import FeatherInfrastructure

extension Author.Table.List {
    var asListItem: Author.List.Output.Item {
        .init(
            id: id,
            name: name,
            excerpt: excerpt,
            profileImageAssetId: profileImageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Author.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list() async throws -> Author.List.Output {
            let rows = try await DatabaseAccessLayer<Author.Table>(
                context: context
            )
            .select(as: Author.Table.List.self) { initial in
                initial
                    .order(by: [
                        .init(by: \.createdAt, .descending),
                        .init(by: \.id, .ascending),
                    ])
                    .limit(10_000)
            }
            return .init(items: rows.map(\.asListItem))
        }
    }
}
