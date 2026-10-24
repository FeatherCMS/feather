import FeatherDatabase
import FeatherInfrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeDetailNewsletterCampaign() -> Campaign.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Campaign.Detail.Scope(
                    campaign: Campaign.Detail.Query.Database(context: context)
                )
            }
        )
        return Campaign.Detail.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
