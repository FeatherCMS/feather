import AccountApplication
import AccountInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure
import UserInfrastructure

extension UseCases {

    func makeResendInvitation() -> AccountApplication.ResendInvitation {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteInvitationOnly(
                    invitation: InvitationDatabaseRepository(context: context),
                    role: RoleDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            mailSender: mailSender,
            publicBaseURL: publicBaseURL
        )
    }
}
