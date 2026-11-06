public import BlogApplication
public import BlogModule
public import FeatherInfrastructure

extension AuthorLink.List.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list(authorId: String) async throws
            -> AuthorLink.List.Output
        {
            let value = try await BlogApplication.Public.AuthorLink.List.Query
                .Database(
                    context: context
                )
                .list(authorId: authorId)
            return .init(
                items: value.items.map {
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
