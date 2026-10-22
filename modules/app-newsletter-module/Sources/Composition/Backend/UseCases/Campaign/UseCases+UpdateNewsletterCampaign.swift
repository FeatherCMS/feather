import NewsletterApplication
import FeatherDatabase
import FeatherInfrastructure
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeUpdateNewsletterCampaign() -> Campaign.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Campaign.Edit.Scope(
                    campaign: CampaignDatabaseRepository(context: context)
                )
            }
        )
        return Campaign.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
