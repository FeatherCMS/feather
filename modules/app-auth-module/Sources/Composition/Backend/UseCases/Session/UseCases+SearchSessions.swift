import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherApplication
import FeatherInfrastructure

extension UseCases {
    func makeSearchSessions() -> Session.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Session.Search.Scope(
                    session: Session.Search.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
