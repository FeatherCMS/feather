import AccountAdminAPI
import AccountAppAPI
import AccountApplication
import AccountInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import UserApplication
import UserInfrastructure

public struct UseCases: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let authorizer: any Authorizer
    let mailSender: any MailSender
    let events: any EventPublisher
    let credentialWriter: any InvitationCredentialWriter
    let publicBaseURL: String

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer,
        mailSender: any MailSender,
        events: any EventPublisher,
        credentialWriter: any InvitationCredentialWriter,
        publicBaseURL: String
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
        self.mailSender = mailSender
        self.events = events
        self.credentialWriter = credentialWriter
        self.publicBaseURL = publicBaseURL
    }

}
