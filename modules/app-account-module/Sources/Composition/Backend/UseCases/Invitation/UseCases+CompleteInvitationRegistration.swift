import AccountApplication
import AccountInfrastructure
import AuthInfrastructure
import FeatherInfrastructure
import UserInfrastructure

extension UseCases {

    func makeCompleteInvitationRegistration()
        -> AccountApplication.CompleteInvitationRegistration
    {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteInvitation(
                    invitation: InvitationDatabaseRepository(context: context),
                    identity: Identity.Repository.Database(context: context),
                    role: Role.Repository.Database(context: context),
                    authEmail: AuthEmailDatabaseRepository(context: context),
                    credential: credentialWriter
                )
            }
        )
        return .init(
            transaction: transaction
        )
    }
}
