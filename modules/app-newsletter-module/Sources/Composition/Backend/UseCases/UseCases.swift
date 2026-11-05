public import FeatherInfrastructure
public import FeatherModuleKit
public import NewsletterApplication
public import NewsletterModule

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer
    let jobs: any Issue.JobController.Interface

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer,
        jobs: any Issue.JobController.Interface
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
        self.jobs = jobs
    }

}
