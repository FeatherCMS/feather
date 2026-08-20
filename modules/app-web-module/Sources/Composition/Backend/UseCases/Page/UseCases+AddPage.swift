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

    func makeAddPage() -> AddPage {
            let transaction = DatabaseTransactionExecutor(
                database: database,
                idGenerator: idGenerator,
                scope: { context in
                    WritePageMetadata(
                        page: PageDatabaseRepository(context: context),
                        metadata: MetadataDatabaseRepository(context: context),
                        settings: SettingsDatabaseRepository(context: context),
                        variable: VariableDatabaseQueries(
                            context: .init(connection: context.connection)
                        )
                    )
                }
            )
            return .init(
                authorizer: authorizer,
                transaction: transaction
            )
        }
}

