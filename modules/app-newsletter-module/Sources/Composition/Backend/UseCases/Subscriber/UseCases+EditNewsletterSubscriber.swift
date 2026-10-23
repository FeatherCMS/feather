import NewsletterApplication
import NewsletterModule
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeEditNewsletterSubscriber() -> Subscriber.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.Edit.Scope(
                    newsletter: Campaign.Repository.Database(context: context),
                    subscriber: Subscriber.Repository.Database(context: context)
                )
            }
        )
        return Subscriber.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
