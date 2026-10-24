import NewsletterApplication
import NewsletterModule
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeSendNewsletterTestEmail() -> Issue.TestEmail.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.TestEmail.Scope(
                    newsletter: Campaign.Repository.Database(context: context)
                )
            }
        )
        return Issue.TestEmail.UseCase(
            authorizer: authorizer,
            transaction: transaction,
            jobs: jobs
        )
    }
}
