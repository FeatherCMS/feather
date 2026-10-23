import NewsletterApplication
import NewsletterModule
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeListNewsletterSubscribers() -> Subscriber.List.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.List.Scope(
                    newsletter: Campaign.Repository.Database(context: context),
                    subscriber: Subscriber.Repository.Database(context: context)
                )
            }
        )
        return Subscriber.List.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
