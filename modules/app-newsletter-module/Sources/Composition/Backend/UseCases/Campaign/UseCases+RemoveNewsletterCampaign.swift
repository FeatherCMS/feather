import NewsletterApplication
import FeatherDatabase
import FeatherInfrastructure
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeRemoveNewsletterCampaign() -> Campaign.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Campaign.Remove.Scope(
                    campaign: CampaignDatabaseRepository(context: context)
                )
            }
        )
        return Campaign.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
