import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeAddNewsletterIssue() -> Issue.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.Add.Scope(
                    newsletter: CampaignDatabaseRepository(context: context),
                    issue: IssueDatabaseRepository(context: context)
                )
            }
        )
        return Issue.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
