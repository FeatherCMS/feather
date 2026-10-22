import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeScheduleNewsletterIssue() -> Issue.Schedule.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.Schedule.Scope(
                    issue: IssueDatabaseRepository(context: context)
                )
            }
        )
        return Issue.Schedule.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
