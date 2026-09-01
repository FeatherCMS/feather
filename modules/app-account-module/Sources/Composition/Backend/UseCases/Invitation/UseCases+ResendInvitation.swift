import AccountApplication
import AccountInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import UserInfrastructure

extension UseCases {

    func makeResendInvitation() -> AccountApplication.ResendInvitation {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteInvitationOnlyWithVariable(
                    invitation: InvitationDatabaseRepository(context: context),
                    role: RoleDatabaseRepository(context: context),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            mailSender: mailSender
        )
    }
}
