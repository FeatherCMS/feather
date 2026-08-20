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

    func makeGetCredential() -> GetCredential {
            let query = DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadCredentialLink(
                        credential: CredentialDatabaseQueries(
                            context: context
                        )
                    )
                }
            )
            return GetCredential(authorizer: authorizer, query: query)
        }
}

