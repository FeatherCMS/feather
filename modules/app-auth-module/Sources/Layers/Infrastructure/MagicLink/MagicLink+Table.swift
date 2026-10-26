import AuthModule
import FeatherDBAL
import Foundation

extension MagicLink {
    struct Table: DatabaseTable {
        static let name = "auth_magic_link"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let authEmailId = DatabaseTableColumn<String>(name: "auth_email_id")
            let token = DatabaseTableColumn<String>(name: "token")
            let expiresAt = DatabaseTableColumn<Date>(name: "expires_at")
            let isPersistent = DatabaseTableColumn<Bool>(name: "is_persistent")
            let isUsed = DatabaseTableColumn<Bool>(name: "is_used")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
