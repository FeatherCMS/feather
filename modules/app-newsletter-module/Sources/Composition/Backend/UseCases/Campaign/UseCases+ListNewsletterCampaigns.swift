import NewsletterApplication
import NewsletterModule
import FeatherDatabase
import FeatherInfrastructure
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeListNewsletterCampaigns() -> Campaign.List.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Campaign.List.Scope(
                    campaign: Campaign.Repository.Database(context: context)
                )
            }
        )
        return Campaign.List.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
