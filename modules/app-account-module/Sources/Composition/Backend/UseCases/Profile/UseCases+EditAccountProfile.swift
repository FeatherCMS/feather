import AccountApplication
import AccountInfrastructure
import FeatherInfrastructure

extension UseCases {
    func makeEditAccountProfile() -> AccountApplication.EditAccountProfile {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteAccountProfile(
                    profile: AccountProfileDatabaseRepository(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
