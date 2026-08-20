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

    func makeAddCredential() -> AddCredential {
            let transaction = DatabaseTransactionExecutor(
                database: database,
                idGenerator: idGenerator,
                scope: { context in
                    WriteCredentialLink(
                        credential: CredentialDatabaseRepository(context: context)
                    )
                }
            )
            return AddCredential(
                authorizer: authorizer,
                transaction: transaction,
                passwordHasher: BCryptPasswordHasher()
            )
        }
}

