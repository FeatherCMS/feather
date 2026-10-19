import SystemModule
import AccountApplication
import AccountInfrastructure
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import UserInfrastructure

extension UseCases {

    func makeResendInvitation() -> AccountApplication.ResendInvitation {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteInvitationOnlyWithVariable(
                    invitation: InvitationDatabaseRepository(context: context),
                    role: RoleDatabaseRepository(context: context),
                    variable: SystemModule.Variable.Lookup.Database(
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
