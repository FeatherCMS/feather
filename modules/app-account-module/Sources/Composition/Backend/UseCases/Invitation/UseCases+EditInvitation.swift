import AccountApplication
import AccountInfrastructure
import FeatherInfrastructure
import UserInfrastructure

extension UseCases {

    func makeEditInvitation() -> EditInvitation {
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
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
