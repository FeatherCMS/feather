import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeSubscribeToNewsletter() -> Subscriber.Subscribe.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.Subscribe.Scope(
                    newsletter: CampaignDatabaseRepository(context: context),
                    subscriber: SubscriberDatabaseRepository(context: context)
                )
            }
        )
        return Subscriber.Subscribe.UseCase(transaction: transaction)
    }
}
