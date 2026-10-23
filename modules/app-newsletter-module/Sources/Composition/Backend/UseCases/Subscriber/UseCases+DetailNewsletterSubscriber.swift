import NewsletterApplication
import NewsletterModule
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeDetailNewsletterSubscriber() -> Subscriber.Detail.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.Detail.Scope(
                    newsletter: Campaign.Repository.Database(context: context),
                    subscriber: Subscriber.Repository.Database(context: context)
                )
            }
        )
        return Subscriber.Detail.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
