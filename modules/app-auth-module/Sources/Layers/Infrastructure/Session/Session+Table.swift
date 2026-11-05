import AuthModule
import FeatherDBAL
import Foundation

extension Session {
    struct Table: DatabaseTable {
        static let name = "auth_session"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let token = DatabaseTableColumn<String>(name: "token")
            let identityId = DatabaseTableColumn<String>(name: "identity_id")
            let authenticationType = DatabaseTableColumn<String>(
                name: "authentication_type"
            )
            let authenticationReference = DatabaseTableColumn<String>(
                name: "authentication_reference"
            )
            let isPersistent = DatabaseTableColumn<Bool>(name: "is_persistent")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
            let expiresAt = DatabaseTableColumn<Date>(name: "expires_at")
        }
    }
}
