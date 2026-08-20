import AccountAdminAPI
import AccountAppAPI
import AccountApplication
import AccountInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import UserApplication
import UserInfrastructure

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
