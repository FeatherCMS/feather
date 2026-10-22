import AccountApplication
import AccountInfrastructure
import AccountModule
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    func makeRemoveInvitation() -> Invitation.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Invitation.Remove.Scope(
                    invitation: Invitation.Repository.Database(
                        context: context
                    ),
                    identity: Identity.Repository.Database(context: context),
                    authEmail: Email.Repository.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
