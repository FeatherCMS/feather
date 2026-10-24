import AccountApplication
import AccountInfrastructure
import AccountModule
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    func makeEditInvitation() -> Invitation.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Invitation.Edit.Scope(
                    invitation: Invitation.Repository.Database(
                        context: context
                    ),
                    identity: Identity.Repository.Database(context: context),
                    role: Role.Repository.Database(context: context),
                    authEmail: Email.Repository.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
