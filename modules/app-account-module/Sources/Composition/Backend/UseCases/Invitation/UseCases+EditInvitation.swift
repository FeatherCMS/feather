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
                    identity: Identity.Repository.Database(context: context),
                    role: Role.Repository.Database(context: context),
                    authEmail: AuthEmail.Repository.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
