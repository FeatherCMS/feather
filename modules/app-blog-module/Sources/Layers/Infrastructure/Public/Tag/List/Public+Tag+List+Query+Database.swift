public import BlogApplication
import BlogModule
import FeatherDBAL
public import FeatherInfrastructure

extension Public.Tag.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list() async throws -> Output {
            let result = try await DatabaseAccessLayer<Tag.Table>(
                context: context
            )
            .select(as: Tag.Table.List.self) {
                $0.order(by: [
                    .init(by: \.createdAt, .descending),
                    .init(by: \.id, .ascending),
                ])
                .limit(10_000)
            }
            return .init(
                items: result.map {
                    .init(
                        id: $0.id,
                        title: $0.title,
                        excerpt: $0.excerpt,
                        imageAssetId: $0.imageAssetId
                    )
                }
            )
        }
    }
}
