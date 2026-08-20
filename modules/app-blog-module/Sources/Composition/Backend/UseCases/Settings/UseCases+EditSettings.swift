import BlogApplication
import BlogInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaBackend
import SystemInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeEditSettings() -> EditSettings {
            let transaction = DatabaseTransactionExecutor(
                database: database,
                idGenerator: idGenerator,
                scope: { context in
                    WriteSettings(
                        settings: SettingsDatabaseRepository(context: context)
                    )
                }
            )
            return .init(authorizer: authorizer, transaction: transaction)
        }
}

