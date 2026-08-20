import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Foundation
import SystemInfrastructure
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebInfrastructure

extension UseCases {

    func makeListPublicMenus() -> ListPublicMenus {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadPublicMenu(
                    menu: MenuDatabaseQueries(
                        context: context
                    ),
                    menuItem: MenuItemDatabaseQueries(
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
