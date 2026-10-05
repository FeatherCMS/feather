public import FeatherContracts
import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure

public struct UseCases: Sendable {

    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
    }

}
