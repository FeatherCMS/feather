import NewsletterApplication
import NewsletterModule
import FeatherDatabase
import FeatherInfrastructure
import NewsletterInfrastructure

extension UseCases {

    func makeAddCampaign() -> Campaign.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Campaign.Add.Scope(
                    campaign: Campaign.Repository.Database(context: context)
                )
            }
        )
        return Campaign.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
