import AccountApplication
import AccountInfrastructure
import AuthInfrastructure
import FeatherInfrastructure
import UserInfrastructure

extension UseCases {

    func makeEditInvitation() -> EditInvitation {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteInvitationOnly(
                    invitation: InvitationDatabaseRepository(context: context),
                    identity: IdentityDatabaseRepository(context: context),
                    role: RoleDatabaseRepository(context: context),
                    authEmail: AuthEmailDatabaseRepository(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
