import AuthAdminAPI
import AuthAppAPI
import AuthApplication
import AuthContracts
import AuthInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemApplication
import SystemContracts
import UserApplication
import UserBackend
import UserContracts
import UserInfrastructure

public struct UseCases: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let authorizer: any Authorizer
    public let user: UserBackend.UseCases

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer,
        user: UserBackend.UseCases
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
        self.user = user
    }
}

struct NoopMailSender: MailSender {
    func send(
        _ message: MailMessage
    ) async throws {}
}
