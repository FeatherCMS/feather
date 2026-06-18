import Domain
import struct Foundation.Date

public struct RolePermission: Model {

    public enum Error: DomainError {
        case roleIdTooShort
        case roleIdTooLong
        case permissionIdTooShort
        case permissionIdTooLong
    }

    public struct New: Sendable {
        public let roleId: String
        public let permissionId: String
    }

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

public extension RolePermission {

    private static func validate(
        roleId: String
    ) throws(Self.Error) {
        guard roleId.count > 3 else {
            throw .roleIdTooShort
        }
        guard roleId.count < 255 else {
            throw .roleIdTooLong
        }
    }

    private static func validate(
        permissionId: String
    ) throws(Self.Error) {
        guard permissionId.count > 3 else {
            throw .permissionIdTooShort
        }
        guard permissionId.count < 255 else {
            throw .permissionIdTooLong
        }
    }

    static func create(
        roleId: String,
        permissionId: String
    ) throws(Self.Error) -> Self.New {
        try validate(roleId: roleId)
        try validate(permissionId: permissionId)

        return .init(
            roleId: roleId,
            permissionId: permissionId
        )
    }
}
