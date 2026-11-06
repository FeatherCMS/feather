import AccountApplication
import AccountInfrastructure
import AccountModule
import FeatherInfrastructure

extension UseCases {

    func makeListInvitations() -> Invitation.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Invitation.List.Scope(
                    query: Invitation.List.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

}
