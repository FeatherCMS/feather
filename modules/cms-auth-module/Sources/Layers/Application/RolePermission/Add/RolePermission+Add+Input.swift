public import AuthModule
public import FeatherApplication

extension RolePermission.Add {
    public struct Input: DTO, Sendable {
        public let roleId: String
        public let permissionId: String

        public init(roleId: String, permissionId: String) {
            self.roleId = roleId
            self.permissionId = permissionId
        }
    }
}
