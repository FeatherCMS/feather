import FeatherDatabase
import FeatherInfrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeDetailNewsletterSubscriber() -> Subscriber.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.Detail.Scope(
                    subscriber: Subscriber.Detail.Query.Database(
                        context: context
                    )
                )
            }
        )
        return Subscriber.Detail.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
