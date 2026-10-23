import NewsletterApplication
import NewsletterModule
import FeatherDatabase
import FeatherInfrastructure
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeEditNewsletterCampaign() -> Campaign.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Campaign.Edit.Scope(
                    campaign: Campaign.Repository.Database(context: context)
                )
            }
        )
        return Campaign.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
