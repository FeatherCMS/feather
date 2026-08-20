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

    func makeRemoveInvitation() -> RemoveInvitation {
            let transaction = DatabaseTransactionExecutor(
                database: database,
                idGenerator: idGenerator,
                scope: { context in
                    WriteInvitationOnly(
                        invitation: InvitationDatabaseRepository(context: context)
                    )
                }
            )
            return .init(authorizer: authorizer, transaction: transaction)
        }
}

