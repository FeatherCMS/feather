import AuthModule
import FeatherDBAL
import Foundation

extension RolePermission.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let roleId: String
        let permissionId: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[RolePermission.Table.columns.createdAt] = .currentTimestamp
            values[RolePermission.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case roleId = "role_id"
            case permissionId = "permission_id"
        }
    }
}

extension RolePermission.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let permissionId: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[RolePermission.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case permissionId = "permission_id"
        }
    }
}

extension RolePermission.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let roleId: String
        let permissionId: String
        let createdAt: Date
        let updatedAt: Date
    }
}

extension RolePermission.Table: DatabaseTableWithDelete {}
