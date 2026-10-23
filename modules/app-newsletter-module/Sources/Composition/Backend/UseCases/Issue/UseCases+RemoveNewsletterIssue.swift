import NewsletterApplication
import NewsletterModule
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeRemoveNewsletterIssue() -> Issue.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.Remove.Scope(
                    newsletter: Campaign.Repository.Database(context: context),
                    issue: Issue.Repository.Database(context: context),
                    delivery: Delivery.Repository.Database(context: context)
                )
            }
        )
        return Issue.Remove.UseCase(authorizer: authorizer, transaction: transaction)
    }
}
