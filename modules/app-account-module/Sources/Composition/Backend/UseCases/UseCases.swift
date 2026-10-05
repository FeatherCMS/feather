import AccountApplication
public import FeatherApplication
public import FeatherContracts
import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer
    let jobs: any MailSender
    let events: any EventPublisher
    let credentialWriter: any InvitationCredentialWriter

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer,
        jobs: any MailSender,
        events: any EventPublisher
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
        self.jobs = jobs
        self.events = events
        self.credentialWriter = InvitationCredentialWriterAdapter()
    }

    var mailSender: any MailSender { jobs }

}
