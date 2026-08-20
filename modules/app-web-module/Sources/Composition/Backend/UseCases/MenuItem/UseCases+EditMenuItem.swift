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

    func makeEditMenuItem() -> EditMenuItem {
            let transaction = DatabaseTransactionExecutor(
                database: database,
                idGenerator: idGenerator,
                scope: { context in
                    WriteMenuItem(
                        menuItem: MenuItemDatabaseRepository(context: context)
                    )
                }
            )
            return .init(
                authorizer: authorizer,
                transaction: transaction
            )
        }
}

