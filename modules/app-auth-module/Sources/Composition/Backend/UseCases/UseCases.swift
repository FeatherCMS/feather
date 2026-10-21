public import FeatherApplication
import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure
public import FeatherModuleKit

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer
    let jobs: any SendMailJobController

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer,
        jobs: any SendMailJobController
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
        self.jobs = jobs
    }

}
