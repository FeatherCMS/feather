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

    public func makeGetCurrentUser() -> AuthApplication.GetCurrentUser {
            let query = DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadIdentity(
                        identity: IdentityDatabaseQueries(
                            context: context
                        )
                    )
                }
            )
            return .init(
                authorizer: authorizer,
                query: query
            )
        }
}

