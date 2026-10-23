import NewsletterApplication
import NewsletterModule
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
                    campaign: Campaign.Repository.Database(context: context)
                )
            }
        )
        return Campaign.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
