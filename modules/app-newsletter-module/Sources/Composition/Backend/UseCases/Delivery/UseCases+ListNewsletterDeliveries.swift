import NewsletterApplication
import NewsletterModule
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeListNewsletterDeliveries() -> Delivery.List.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Delivery.List.Scope(
                    newsletter: Campaign.Repository.Database(context: context),
                    issue: Issue.Repository.Database(context: context),
                    delivery: Delivery.Repository.Database(context: context)
                )
            }
        )
        return Delivery.List.UseCase(authorizer: authorizer, transaction: transaction)
    }
}
