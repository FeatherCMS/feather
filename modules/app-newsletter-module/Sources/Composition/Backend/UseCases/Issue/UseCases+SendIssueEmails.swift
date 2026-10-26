import FeatherDatabase
import FeatherInfrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeSendIssueEmails() -> Issue.Send.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.Send.Scope(
                    newsletter: Campaign.Repository.Database(context: context),
                    subscriber: Subscriber.Repository.Database(
                        context: context
                    ),
                    delivery: Delivery.Repository.Database(context: context)
                )
            }
        )
        return Issue.Send.UseCase(
            authorizer: authorizer,
            transaction: transaction,
            jobs: jobs
        )
    }
}
