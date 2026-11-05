import FeatherApplication
import FeatherDatabase
import FeatherInfrastructure
import FeatherModuleKit
import SystemInfrastructure
import WebApplication
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {
    func makeDetailPublicMenu() -> Menu.Public.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Menu.Public.Detail.Scope(
                    query: Menu.Public.Detail.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
