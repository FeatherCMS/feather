public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure

extension UseCases {

    public func makeDetailAuthorLink() -> AuthorLink.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                AuthorLink.Detail.Scope(
                    authorLink: AuthorLink.Detail.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
