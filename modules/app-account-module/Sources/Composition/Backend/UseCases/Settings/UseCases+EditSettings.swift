import AccountApplication
import AccountInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeEditSettings() -> AccountApplication.EditSettings {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
