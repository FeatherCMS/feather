import FeatherInfrastructure
import UserApplication
import UserInfrastructure

extension UseCases {

    func makeEditIdentity() -> EditIdentity {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteIdentityRole(
                    identity: IdentityDatabaseRepository(context: context),
                    role: RoleDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
