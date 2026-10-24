import AuthModule
import FeatherDBAL
import Foundation

extension RolePermission.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let roleId: String
        let permissionId: String
    }
    }

    extension RolePermission.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let permissionId: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[RolePermission.Table.columns.updatedAt] = .currentTimestamp
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
