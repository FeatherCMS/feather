import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import WebApplication
import WebDomain
import WebInfrastructure

extension UseCases {
    func makeSearchPages() -> Page.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Page.Search.Scope(
                    page: Page.Search.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
