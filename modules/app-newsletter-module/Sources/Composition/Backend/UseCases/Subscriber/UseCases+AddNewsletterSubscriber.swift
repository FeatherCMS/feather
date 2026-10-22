import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeAddNewsletterSubscriber() -> Subscriber.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.Add.Scope(
                    newsletter: CampaignDatabaseRepository(context: context),
                    subscriber: SubscriberDatabaseRepository(context: context)
                )
            }
        )
        return Subscriber.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
