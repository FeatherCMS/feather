import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeSubscribeToNewsletter() -> Subscriber.Subscribe.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.Subscribe.Scope(
                    newsletter: Campaign.Repository.Database(context: context),
                    subscriber: Subscriber.Repository.Database(context: context)
                )
            }
        )
        return Subscriber.Subscribe.UseCase(transaction: transaction)
    }
}
