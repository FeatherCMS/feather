import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeGetSession() -> GetSession {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
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
