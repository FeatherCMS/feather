import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeListNewsletterDeliveries() -> Delivery.List.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Delivery.List.Scope(
                    newsletter: CampaignDatabaseRepository(context: context),
                    issue: IssueDatabaseRepository(context: context),
                    delivery: DeliveryDatabaseRepository(context: context)
                )
            }
        )
        return Delivery.List.UseCase(authorizer: authorizer, transaction: transaction)
    }
}
