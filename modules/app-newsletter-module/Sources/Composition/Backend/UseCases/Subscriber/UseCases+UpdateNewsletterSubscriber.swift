import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeUpdateNewsletterSubscriber() -> Subscriber.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.Edit.Scope(
                    newsletter: CampaignDatabaseRepository(context: context),
                    subscriber: SubscriberDatabaseRepository(context: context)
                )
            }
        )
        return Subscriber.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
