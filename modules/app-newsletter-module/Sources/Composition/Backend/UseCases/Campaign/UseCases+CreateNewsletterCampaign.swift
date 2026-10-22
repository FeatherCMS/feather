import NewsletterApplication
import FeatherDatabase
import FeatherInfrastructure
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeCreateNewsletterCampaign() -> Campaign.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Campaign.Add.Scope(
                    campaign: CampaignDatabaseRepository(context: context)
                )
            }
        )
        return Campaign.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
