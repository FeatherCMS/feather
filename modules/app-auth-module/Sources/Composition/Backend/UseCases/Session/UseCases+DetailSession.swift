import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeDetailSession() -> Session.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Session.Detail.Scope(
                    session: Session.Detail.Query.Database(
                        context: context
                    )
                )
            }
        )
        return Session.Detail.UseCase(authorizer: authorizer, query: query)
    }
}
