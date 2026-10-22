import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeSendNewsletterIssueEmails() -> Issue.Send.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.Send.Scope(
                    newsletter: CampaignDatabaseRepository(context: context),
                    subscriber: SubscriberDatabaseRepository(context: context),
                    delivery: DeliveryDatabaseRepository(context: context)
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
