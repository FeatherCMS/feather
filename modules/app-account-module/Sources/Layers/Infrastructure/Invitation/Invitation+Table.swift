import AccountModule
import FeatherDBAL
import FeatherInfrastructure
import Foundation

extension Invitation {
    enum Table: DatabaseTable {
        static let name = "account_invitation"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let userId = DatabaseTableColumn<String>(name: "user_id")
            let email = DatabaseTableColumn<String>(name: "email")
            let token = DatabaseTableColumn<String>(name: "token")
            let roleIds = DatabaseTableColumn<String>(name: "role_ids")
            let expiresAt = DatabaseTableColumn<Date>(name: "expires_at")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
