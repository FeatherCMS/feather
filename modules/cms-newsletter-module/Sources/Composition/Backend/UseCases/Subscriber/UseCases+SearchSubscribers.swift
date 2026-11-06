import FeatherInfrastructure
import NewsletterApplication
import NewsletterDomain
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {
    func makeSearchSubscribers() -> Subscriber.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Subscriber.Search.Scope(
                    subscriber: Subscriber.Search.Query.Database(
                        context: context
                    )
                )
            }
        )
        return Subscriber.Search.UseCase(authorizer: authorizer, query: query)
    }
}
