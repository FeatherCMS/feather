import FeatherInfrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {
    func makeSearchNewsletterCampaigns() -> Campaign.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Campaign.Search.Scope(
                    campaign: Campaign.Search.Query.Database(context: context)
                )
            }
        )
        return Campaign.Search.UseCase(authorizer: authorizer, query: query)
    }
}
