public import FeatherApplication
public import FeatherContracts
import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer
    let jobs: any MailSender

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer,
        jobs: any MailSender
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
        self.jobs = jobs
    }

    var mailSender: any MailSender { jobs }
}
