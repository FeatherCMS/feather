import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeListIdentitySessions() -> Session.ListByIdentity.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Session.ListByIdentity.Scope(
                    session: Session.List.Query.Database(
                        context: context
                    )
                )
            }
        )
        return Session.ListByIdentity.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
