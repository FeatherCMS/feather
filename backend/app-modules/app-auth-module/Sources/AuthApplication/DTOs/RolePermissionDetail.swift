import Application
import struct Foundation.Date

public struct RolePermissionDetail: DTO {
    public let roleId: String
    public let permissionId: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        roleId: String,
        permissionId: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.roleId = roleId
        self.permissionId = permissionId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
