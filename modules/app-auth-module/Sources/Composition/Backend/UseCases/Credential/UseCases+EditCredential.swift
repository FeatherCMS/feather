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

    func makeEditCredential() -> EditCredential {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteCredentialLink(
                    credential: CredentialDatabaseRepository(context: context)
                )
            }
        )
        return EditCredential(
            authorizer: authorizer,
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher()
        )
    }
}
