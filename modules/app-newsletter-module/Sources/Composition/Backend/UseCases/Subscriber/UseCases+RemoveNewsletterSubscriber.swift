import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeRemoveNewsletterSubscriber() -> Subscriber.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.Remove.Scope(
                    newsletter: CampaignDatabaseRepository(context: context),
                    subscriber: SubscriberDatabaseRepository(context: context)
                )
            }
        )
        return Subscriber.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
