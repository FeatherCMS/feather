import FeatherDBAL
import FeatherInfrastructure
import Foundation
import UserModule

extension Role {
    struct Table: DatabaseTable {
        static let name = "user_role"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let key = DatabaseTableColumn<String>(name: "key")
            let name = DatabaseTableColumn<String?>(name: "name")
            let notes = DatabaseTableColumn<String?>(name: "notes")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
