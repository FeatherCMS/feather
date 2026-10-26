import NewsletterApplication
import NewsletterModule
import FeatherDatabase
import FeatherInfrastructure
import NewsletterInfrastructure

extension UseCases {

    func makeRemoveCampaign() -> Campaign.Remove.UseCase {
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
