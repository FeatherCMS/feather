public import BlogApplication
public import BlogModule
public import FeatherInfrastructure

extension AuthorLink.Search.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            authorId: String,
            query: AuthorLink.Search.Input.Query
        ) async throws -> AuthorLink.Search.Output {
            let database = BlogApplication.Public.AuthorLink.Database(
                    context: context
                )
            let result = try await database.search(
                authorId: authorId,
                query: query
            )
            return .init(
                items: result.items.map {
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
                },
                total: result.total
            )
        }
    }
}
