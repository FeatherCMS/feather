import NewsletterApplication
import NewsletterModule
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeDetailNewsletterIssue() -> Issue.Detail.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.Detail.Scope(
                    newsletter: Campaign.Repository.Database(context: context),
                    issue: Issue.Repository.Database(context: context)
                )
            }
        )
        return Issue.Detail.UseCase(authorizer: authorizer, transaction: transaction)
    }
}
