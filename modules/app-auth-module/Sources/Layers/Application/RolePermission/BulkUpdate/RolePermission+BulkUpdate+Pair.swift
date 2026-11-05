public import AuthModule
public import FeatherApplication

extension RolePermission.BulkUpdate {
    public struct Pair: DTO, Sendable {
        public let roleId: String
        public let permissionId: String

        public init(
            roleId: String,
            permissionId: String
        ) {
            self.roleId = roleId
            self.permissionId = permissionId
        }
    }
}
