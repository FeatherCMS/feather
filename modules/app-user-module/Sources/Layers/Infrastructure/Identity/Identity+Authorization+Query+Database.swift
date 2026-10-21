import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import UserApplication
public import UserModule

extension Identity.Authorization.Query {
    public struct Database: Identity.Authorization.Query.Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func getRolesBy(identityId: String) async throws -> [String] {
            try await Identity.Table(connection: context.connection)
                .listRoleNames(identityId: identityId)
        }

        public func getPermissionsBy(identityId: String) async throws
            -> [String]
        {
            try await Identity.Table(connection: context.connection)
                .listPermissionNames(identityId: identityId)
        }
    }
}
