import FeatherDatabase
import FeatherInfrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeScheduleIssue() -> Issue.Schedule.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.Schedule.Scope(
                    issue: Issue.Repository.Database(context: context)
                )
            }
        )
        return Issue.Schedule.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
