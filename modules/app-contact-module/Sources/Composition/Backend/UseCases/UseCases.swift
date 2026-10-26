import ContactApplication
import ContactInfrastructure
import ContactModule
public import FeatherApplication
public import FeatherInfrastructure
public import FeatherModuleKit

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer
    let jobs: any SendMailJobController
    let events: any EventPublisher

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer,
        jobs: any SendMailJobController,
        events: any EventPublisher
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
        self.jobs = jobs
        self.events = events
    }
}
