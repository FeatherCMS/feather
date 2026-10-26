public import FeatherInfrastructure
public import FeatherModuleKit

public struct UseCases: Sendable {

    let databaseContext: DatabaseClientContext
    public let authorizer: any Authorizer

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
    }
}
