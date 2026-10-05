public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure

extension UseCases {

    public func makeListAuthorLinks() -> ListAuthorLinks {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                ReadAuthorLink(
                    authorLink: AuthorLinkDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
