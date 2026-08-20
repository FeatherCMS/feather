import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import UserAdminAPI
import UserAppAPI
import UserApplication
import UserInfrastructure

extension UseCases {

    func makeAddIdentity() -> AddIdentity {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteIdentity(
                    identity: IdentityDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            events: events
        )
    }
}
