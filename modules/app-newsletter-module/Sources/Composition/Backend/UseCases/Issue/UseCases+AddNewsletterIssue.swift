import NewsletterApplication
import NewsletterModule
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeAddNewsletterIssue() -> Issue.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.Add.Scope(
                    newsletter: Campaign.Repository.Database(context: context),
                    issue: Issue.Repository.Database(context: context)
                )
            }
        )
        return Issue.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
