import AccountAdminAPI
import AccountAppAPI
import AccountApplication
import AccountInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension UseCases {
    func makeGetAccountProfile() -> AccountApplication.GetAccountProfile {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadAccountProfile(
                    profile: AccountProfileDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
