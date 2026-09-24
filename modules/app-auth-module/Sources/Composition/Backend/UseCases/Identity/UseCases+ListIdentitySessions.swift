import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeListIdentitySessions() -> ListIdentitySessions {
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
        return ListIdentitySessions(authorizer: authorizer, query: query)
    }
}
