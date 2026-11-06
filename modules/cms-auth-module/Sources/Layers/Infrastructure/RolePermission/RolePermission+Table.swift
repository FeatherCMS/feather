import AuthModule
import FeatherDBAL
import Foundation

extension RolePermission {
    struct Table: DatabaseTable {
        static let name = "auth_role_permission"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let roleId = DatabaseTableColumn<String>(name: "role_id")
            let permissionId = DatabaseTableColumn<String>(
                name: "permission_id"
            )
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
