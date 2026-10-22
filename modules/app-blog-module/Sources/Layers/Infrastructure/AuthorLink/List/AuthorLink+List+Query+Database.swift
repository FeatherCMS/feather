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
            try await BlogApplication.Public.AuthorLink.Database(context: context)
                .list(authorId: authorId, query: .init())
        }
    }
}
