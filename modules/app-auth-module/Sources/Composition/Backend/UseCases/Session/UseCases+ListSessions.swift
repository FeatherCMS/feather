import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeListSessions() -> Session.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Session.List.Scope(
                    session: Session.List.Query.Database(context: context)
                )
            }
        )
        return Session.List.UseCase(authorizer: authorizer, query: query)
    }
}
