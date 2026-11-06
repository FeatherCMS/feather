import FeatherApplication
import FeatherDatabase
import FeatherInfrastructure
import WebApplication
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {
    func makeListMenuItems() -> MenuItem.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                MenuItem.List.Scope(
                    menuItem: MenuItem.List.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
