public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure

extension UseCases {

    public func makeListAuthorLinks() -> AuthorLink.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                AuthorLink.List.Scope(
                    authorLink: AuthorLink.List.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
