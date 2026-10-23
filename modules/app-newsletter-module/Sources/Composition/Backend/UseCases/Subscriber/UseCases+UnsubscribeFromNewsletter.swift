import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeUnsubscribeFromNewsletter() -> Subscriber.Unsubscribe.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.Unsubscribe.Scope(
                    newsletter: Campaign.Repository.Database(context: context),
                    subscriber: Subscriber.Repository.Database(context: context)
                )
            }
        )
        return Subscriber.Unsubscribe.UseCase(transaction: transaction)
    }
}
