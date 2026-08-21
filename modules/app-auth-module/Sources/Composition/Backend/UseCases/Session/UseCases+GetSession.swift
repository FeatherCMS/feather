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

    func makeGetSession() -> GetSession {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadSession(
                    session: SessionDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return GetSession(authorizer: authorizer, query: query)
    }
}
