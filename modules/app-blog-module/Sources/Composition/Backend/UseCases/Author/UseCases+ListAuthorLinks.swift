import BlogApplication
import BlogInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaBackend
import SystemInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeListAuthorLinks() -> ListAuthorLinks {
            let query = DatabaseQueryExecutor(
                database: database,
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

