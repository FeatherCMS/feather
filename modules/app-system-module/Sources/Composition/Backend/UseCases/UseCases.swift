import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemAdminAPI
import SystemAppAPI
import SystemApplication
import SystemInfrastructure

public struct UseCases: Sendable
{

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

    func aggregatedPermissions() {
        var permissions: [PermissionKey] = []
        permissions += SystemPermissions.allPermissions()

        for permission in permissions {
            print(permission.rawValue)
        }
    }
}

extension UseCases {












}

