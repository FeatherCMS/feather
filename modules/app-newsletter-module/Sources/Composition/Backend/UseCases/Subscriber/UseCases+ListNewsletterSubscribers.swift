import FeatherDatabase
import FeatherInfrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeListNewsletterSubscribers() -> Subscriber.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.List.Scope(
                    subscriber: Subscriber.List.Query.Database(context: context)
                )
            }
        )
        return Subscriber.List.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
