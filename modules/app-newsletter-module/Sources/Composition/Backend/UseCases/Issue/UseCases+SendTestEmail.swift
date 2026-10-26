import FeatherDatabase
import FeatherInfrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeSendTestEmail() -> Issue.TestEmail.UseCase {
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
