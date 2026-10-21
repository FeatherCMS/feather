import FeatherDBAL
import FeatherInfrastructure
import Foundation
import UserModule

enum IdentityRole {
    struct Table: DatabaseTable {
        static let name = "user_identity_role"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let roleId = DatabaseTableColumn<String>(name: "role_id")
            let identityId = DatabaseTableColumn<String>(name: "identity_id")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
