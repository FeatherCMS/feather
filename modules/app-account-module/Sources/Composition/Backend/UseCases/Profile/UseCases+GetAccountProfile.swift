import AccountApplication
import AccountInfrastructure
import FeatherInfrastructure

extension UseCases {
    func makeGetAccountProfile() -> AccountApplication.GetAccountProfile {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
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
