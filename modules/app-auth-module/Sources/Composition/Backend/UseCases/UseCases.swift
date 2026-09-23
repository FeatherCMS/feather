public import FeatherApplication
public import FeatherContracts
public import FeatherDatabase
public import FeatherDomain

public struct UseCases: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let authorizer: any Authorizer
    let mailSender: any MailSender

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer,
        mailSender: any MailSender
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
        self.mailSender = mailSender
    }
}
