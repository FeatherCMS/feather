import FeatherApplication
public import FeatherContracts
import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure
import SystemInfrastructure
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebInfrastructure

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

extension UseCases {

}
