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

    func makeRemoveCredential() -> RemoveCredential {
            let transaction = DatabaseTransactionExecutor(
                database: database,
                idGenerator: idGenerator,
                scope: { context in
                    WriteCredentialLink(
                        credential: CredentialDatabaseRepository(context: context)
                    )
                }
            )
            return RemoveCredential(
                authorizer: authorizer,
                transaction: transaction
            )
        }
}

