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

    func makeListCredential() -> ListCredential {
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
            return ListCredential(authorizer: authorizer, query: query)
        }
}

