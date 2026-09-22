import FeatherContracts
import FeatherDatabase
import FeatherDomain

public struct UseCases: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let authorizer: any Authorizer
    let events: any EventPublisher

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer,
        events: any EventPublisher
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
        self.events = events
    }
}

extension UseCases {

}
