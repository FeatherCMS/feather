import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeListNewsletterIssues() -> Issue.List.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.List.Scope(
                    newsletter: CampaignDatabaseRepository(context: context),
                    issue: IssueDatabaseRepository(context: context)
                )
            }
        )
        return Issue.List.UseCase(authorizer: authorizer, transaction: transaction)
    }
}
