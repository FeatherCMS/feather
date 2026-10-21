import AuthModule
import FeatherDBAL
import Foundation

extension AuthEmail {
    struct Table: DatabaseTable {
        static let name = "auth_email"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let identityId = DatabaseTableColumn<String>(name: "identity_id")
            let email = DatabaseTableColumn<String>(name: "email")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
