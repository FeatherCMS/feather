import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeUnsubscribeFromNewsletter() -> Subscriber.Unsubscribe.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.Unsubscribe.Scope(
                    newsletter: CampaignDatabaseRepository(context: context),
                    subscriber: SubscriberDatabaseRepository(context: context)
                )
            }
        )
        return Subscriber.Unsubscribe.UseCase(transaction: transaction)
    }
}
