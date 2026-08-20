import AuthAdminAPI
import AuthAppAPI
import AuthApplication
import AuthInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemApplication
import UserApplication
import UserBackend
import UserInfrastructure

extension UseCases {

    func makeRemoveSession() -> RemoveSession {
            let transaction = DatabaseTransactionExecutor(
                database: database,
                idGenerator: idGenerator,
                scope: { context in
                    WriteSession(
                        session: SessionDatabaseRepository(context: context)
                    )
                }
            )
            return RemoveSession(
                authorizer: authorizer,
                transaction: transaction
            )
        }
}

