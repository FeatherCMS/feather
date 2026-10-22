import NewsletterApplication
import NewsletterInfrastructure
import FeatherDatabase
import FeatherInfrastructure

extension UseCases {

    func makeSendNewsletterTestEmail() -> Issue.TestEmail.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.TestEmail.Scope(
                    newsletter: CampaignDatabaseRepository(context: context)
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
