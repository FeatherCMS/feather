import Application

public struct RolePermissionCreate: DTO {
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
