public import FeatherContracts
import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer
    let events: any EventPublisher

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer,
        events: any EventPublisher
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
        self.events = events
    }

}

extension UseCases {

}
