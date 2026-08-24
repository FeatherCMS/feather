import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Foundation
import SystemInfrastructure
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebInfrastructure

public struct UseCases: Sendable {

    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    public let authorizer: any Authorizer

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
    }
}

extension UseCases {

}
