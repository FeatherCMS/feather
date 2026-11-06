import AccountApplication
import AccountInfrastructure
import AccountModule
import FeatherInfrastructure

extension UseCases {
    func makeEditProfile() -> Profile.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Profile.Edit.Scope(
                    profile: Profile.Repository.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
