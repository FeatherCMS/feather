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

extension UseCases {

    func makeListPublicMenus() -> ListPublicMenus {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Menu.PublicScope(
                    menuList: Menu.List.Query.Database(
                        context: context
                    ),
                    menuDetail: Menu.Detail.Query.Database(
                        context: context
                    ),
                    menuItemList: MenuItem.List.Query.Database(
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
