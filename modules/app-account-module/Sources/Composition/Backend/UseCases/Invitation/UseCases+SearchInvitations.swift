import AccountApplication
import AccountInfrastructure
import AccountModule
import FeatherInfrastructure

extension UseCases {
    func makeSearchInvitations() -> Invitation.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Invitation.Search.Scope(
                    query: Invitation.Search.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
