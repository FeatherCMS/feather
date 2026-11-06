public import BlogApplication
import BlogModule
import FeatherDBAL
public import FeatherInfrastructure

extension Public.AuthorLink.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list(authorId: String) async throws -> Output {
            let result = try await DatabaseAccessLayer<AuthorLink.Table>(
                context: context
            )
            .select(as: AuthorLink.Table.List.self) { initial in
                initial
                    .where(\.authorId, equals: authorId)
                    .order(by: \.id)
            }
            return .init(
                items: result.map {
                    .init(
                        id: $0.id,
                        authorId: $0.authorId,
                        label: $0.label,
                        url: $0.url,
                        priority: $0.priority,
                        isBlank: $0.isBlank,
                        permission: $0.permission,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                }
            )
        }
    }
}
