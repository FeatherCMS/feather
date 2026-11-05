import AccountApplication
import AccountInfrastructure
import AccountModule
import FeatherInfrastructure

extension UseCases {

    func makeDetailInvitation() -> Invitation.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Invitation.Detail.Scope(
                    query: Invitation.Detail.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
