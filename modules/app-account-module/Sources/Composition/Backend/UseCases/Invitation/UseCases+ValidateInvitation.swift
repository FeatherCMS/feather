import AccountApplication
import AccountInfrastructure
import AccountModule
import FeatherInfrastructure

extension UseCases {

    func makeValidateInvitation() -> Invitation.Validate.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Invitation.Detail.Scope(
                    query: Invitation.Detail.Query.Database(context: context)
                )
            }
        )
        return .init(query: query)
    }
}
