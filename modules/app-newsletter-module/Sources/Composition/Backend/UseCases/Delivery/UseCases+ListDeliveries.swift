import FeatherDatabase
import FeatherInfrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeListDeliveries() -> Delivery.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Delivery.List.Scope(
                    delivery: Delivery.List.Query.Database(context: context)
                )
            }
        )
        return Delivery.List.UseCase(authorizer: authorizer, query: query)
    }
}
