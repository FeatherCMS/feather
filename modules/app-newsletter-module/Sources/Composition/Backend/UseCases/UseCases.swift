public import FeatherInfrastructure
public import FeatherModuleKit
public import NewsletterApplication

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

}
