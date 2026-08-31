import AccountApplication
import AccountInfrastructure
import FeatherApplication
import FeatherDatabase
import FeatherInfrastructure
import UserInfrastructure

extension UseCases {

    func makeValidateInvitation() -> ValidateInvitation {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadInvitation(
                    invitation: InvitationDatabaseQueries(context: context)
                )
            }
        )
        return .init(query: query)
    }
}
