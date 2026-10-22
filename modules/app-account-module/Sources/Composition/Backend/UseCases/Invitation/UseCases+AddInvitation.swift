import AccountApplication
import AccountInfrastructure
import AccountModule
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule
import UserInfrastructure
import UserModule

extension UseCases {

    func makeAddInvitation() -> Invitation.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Invitation.Add.Scope(
                    invitation: Invitation.Repository.Database(
                        context: context
                    ),
                    identity: Identity.Repository.Database(context: context),
                    role: Role.Repository.Database(context: context),
                    authEmail: Email.Repository.Database(context: context),
                    variable: SystemModule.Variable.Lookup.Database(
                        context: context
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            events: events,
            jobs: jobs
        )
    }
}
