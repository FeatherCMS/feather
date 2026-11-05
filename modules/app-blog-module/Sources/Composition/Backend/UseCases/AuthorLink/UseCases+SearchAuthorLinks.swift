public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure
import WebInfrastructure

extension UseCases {
    public func makeSearchAuthorLinks() -> AuthorLink.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                AuthorLink.Search.Scope(
                    authorLink: AuthorLink.Search.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
