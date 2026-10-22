import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit
import SystemInfrastructure
import WebApplication
import WebDomain
import WebInfrastructure

extension UseCases {
    func makeSearchMenuItems() -> MenuItem.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                MenuItem.Search.Scope(
                    menuItem: MenuItem.Search.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
