import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeRemoveNewsletterIssue() -> Issue.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.Remove.Scope(
                    newsletter: CampaignDatabaseRepository(context: context),
                    issue: IssueDatabaseRepository(context: context),
                    delivery: DeliveryDatabaseRepository(context: context)
                )
            }
        )
        return Issue.Remove.UseCase(authorizer: authorizer, transaction: transaction)
    }
}
