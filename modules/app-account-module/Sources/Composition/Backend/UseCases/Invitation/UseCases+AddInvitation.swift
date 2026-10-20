import SystemModule
import AccountApplication
import AccountInfrastructure
import AuthInfrastructure
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import UserInfrastructure

extension UseCases {

    func makeAddInvitation() -> AddInvitation {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteInvitationWithVariable(
                    invitation: InvitationDatabaseRepository(context: context),
                    identity: Identity.Repository.Database(context: context),
                    role: Role.Repository.Database(context: context),
                    authEmail: AuthEmailDatabaseRepository(context: context),
                    credential: credentialWriter,
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
