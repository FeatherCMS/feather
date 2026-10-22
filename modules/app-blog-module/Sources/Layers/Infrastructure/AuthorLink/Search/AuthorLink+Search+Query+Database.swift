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
            let database = BlogApplication.Public.Query.AuthorLinkContent
                .Database(
                    context: context
                )
            async let list = database.list(authorId: authorId, query: query)
            async let total = database.count(authorId: authorId, query: query)
            let (listResult, totalResult) = try await (list, total)
            let items = listResult.items.map {
                AuthorLink.Search.Output.Item(
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
            return .init(items: items, total: totalResult)
        }
    }
}
