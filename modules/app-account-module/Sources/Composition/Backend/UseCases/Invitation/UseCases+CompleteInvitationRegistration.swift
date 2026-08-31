import AccountAdminAPI
import AccountAppAPI
import AccountApplication
import AccountInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import UserApplication
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
