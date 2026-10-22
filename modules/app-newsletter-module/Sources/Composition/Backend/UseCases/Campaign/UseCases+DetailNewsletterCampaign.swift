import NewsletterApplication
import FeatherDatabase
import FeatherInfrastructure
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeDetailNewsletterCampaign() -> Campaign.Detail.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Campaign.Detail.Scope(
                    campaign: CampaignDatabaseRepository(context: context)
                )
            }
        )
        return Campaign.Detail.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
