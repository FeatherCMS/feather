import AccountApplication
import AccountInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeGetInvitation() -> GetInvitation {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                ReadInvitation(
                    invitation: InvitationDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
