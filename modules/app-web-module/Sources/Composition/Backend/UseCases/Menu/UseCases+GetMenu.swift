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

    func makeGetMenu() -> GetMenu {
            let query = DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadMenu(
                        menu: MenuDatabaseQueries(
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

