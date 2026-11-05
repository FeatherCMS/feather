import AuthModule
import FeatherDBAL
import Foundation

extension Credential {
    struct Table: DatabaseTable {
        static let name = "auth_email_credential"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let authEmailId = DatabaseTableColumn<String>(name: "auth_email_id")
            let passwordHash = DatabaseTableColumn<String>(
                name: "password_hash"
            )
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }

    }
}
