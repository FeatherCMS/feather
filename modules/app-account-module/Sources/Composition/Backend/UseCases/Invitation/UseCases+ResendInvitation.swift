import AccountApplication
import AccountInfrastructure
import AccountModule
import AuthModule
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule
import UserInfrastructure
import UserModule

extension UseCases {

    func makeResendInvitation() -> Invitation.Resend.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Invitation.Resend.Scope(
                    invitation: Invitation.Repository.Database(
                        context: context
                    ),
                    variable: SystemModule.Variable.Lookup.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            jobs: jobs
        )
    }
}
