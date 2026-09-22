import AccountApplication
import AccountInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeListInvitations() -> ListInvitations {
        let query = DatabaseQueryExecutor(
            database: database,
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
