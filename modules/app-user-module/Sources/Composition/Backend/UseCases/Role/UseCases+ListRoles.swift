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

    func makeListRoles() -> ListRoles {
            let query = DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadRole(
                        role: RoleDatabaseQueries(
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

