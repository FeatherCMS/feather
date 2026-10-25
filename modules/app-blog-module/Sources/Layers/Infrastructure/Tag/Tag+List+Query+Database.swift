public import BlogApplication
public import BlogModule
import FeatherDBAL
public import FeatherInfrastructure

extension Tag.List.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext
        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list() async throws -> Tag.List.Output {
            let rows = try await DatabaseAccessLayer<Tag.Table>(
                context: context
            )
            .select(as: Tag.Table.List.self) {
                $0.order(by: \.title).order(by: \.id)
            }
            return .init(
                items: rows.map {
                    .init(
                        id: $0.id,
                        title: $0.title,
                        excerpt: $0.excerpt,
                        imageAssetId: $0.imageAssetId,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                }
            )
        }
    }
}
