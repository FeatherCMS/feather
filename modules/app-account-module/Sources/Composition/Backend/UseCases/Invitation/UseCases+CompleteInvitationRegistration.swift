import AccountApplication
import AccountInfrastructure
import FeatherInfrastructure
import UserInfrastructure

extension UseCases {

    func makeCompleteInvitationRegistration()
        -> AccountApplication.CompleteInvitationRegistration
    {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteInvitation(
                    invitation: InvitationDatabaseRepository(context: context),
                    identity: IdentityDatabaseRepository(context: context),
                    role: RoleDatabaseRepository(context: context),
                    credential: credentialWriter
                )
            }
        )
        return .init(
            transaction: transaction
        )
    }
}
