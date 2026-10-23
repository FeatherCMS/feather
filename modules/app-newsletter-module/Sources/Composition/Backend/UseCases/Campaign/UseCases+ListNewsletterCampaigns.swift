import NewsletterApplication
import NewsletterModule
import FeatherDatabase
import FeatherInfrastructure
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeListNewsletterCampaigns() -> Campaign.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Campaign.List.Scope(
                    campaign: Campaign.List.Query.Database(context: context)
                )
            }
        )
        return Campaign.List.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
