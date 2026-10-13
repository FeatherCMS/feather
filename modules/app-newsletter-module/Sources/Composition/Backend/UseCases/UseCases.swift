public import FeatherContracts
import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure
public import NewsletterApplication
import NewsletterDomain
import NewsletterInfrastructure

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer
    let jobs: any NewsletterIssueJobController

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer,
        jobs: any NewsletterIssueJobController
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
        self.jobs = jobs
    }

    func transaction() -> DatabaseTransactionExecutor<Write> {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Write(
                    newsletter: CampaignDatabaseRepository(context: context),
                    subscriber: SubscriberDatabaseRepository(context: context),
                    issue: IssueDatabaseRepository(context: context),
                    delivery: DeliveryDatabaseRepository(context: context)
                )
            }
        )
    }

}
