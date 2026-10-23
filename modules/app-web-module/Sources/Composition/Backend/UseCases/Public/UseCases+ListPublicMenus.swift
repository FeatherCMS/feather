import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit
import SystemInfrastructure
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    func makeListPublicMenus() -> Menu.Public.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Menu.Public.List.Scope(
                    menuList: Menu.List.Query.Database(
                        context: context
                    ),
                    menuLookup: Menu.Detail.Query.Database(
                        context: context
                    ),
                    menuItems: MenuItem.List.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }
}
