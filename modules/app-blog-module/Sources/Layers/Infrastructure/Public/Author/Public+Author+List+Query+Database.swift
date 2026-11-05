public import BlogApplication
import BlogModule
import FeatherDBAL
public import FeatherInfrastructure

extension Public.Author.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list() async throws -> Output {
            let result = try await DatabaseAccessLayer<Author.Table>(
                context: context
            )
            .select(as: Author.Table.Detail.self) {
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
                        name: $0.name,
                        excerpt: $0.excerpt,
                        content: $0.content,
                        profileImageAssetId: $0.profileImageAssetId
                    )
                }
            )
        }
    }
}
