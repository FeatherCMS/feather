import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeGetNewsletterIssue() -> Issue.Detail.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.Detail.Scope(
                    newsletter: CampaignDatabaseRepository(context: context),
                    issue: IssueDatabaseRepository(context: context)
                )
            }
        )
        return Issue.Detail.UseCase(authorizer: authorizer, transaction: transaction)
    }
}
