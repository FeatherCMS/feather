import AccountApplication
import AccountInfrastructure
import AccountModule
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    func makeCompleteInvitationRegistration()
        -> Invitation.CompleteRegistration.UseCase
    {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Invitation.CompleteRegistration.Scope(
                    invitation: Invitation.Repository.Database(
                        context: context
                    ),
                    identity: Identity.Repository.Database(context: context),
                    authEmail: Email.Repository.Database(context: context),
                    credential: credentialWriter
                )
            }
        )
        return .init(
            transaction: transaction
        )
    }
}
