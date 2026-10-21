import FeatherDBAL
import FeatherInfrastructure
import Foundation
import UserModule

extension Identity {
    struct Table: DatabaseTable {
        static let name = "user_identity"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let name = DatabaseTableColumn<String>(name: "name")
            let status = DatabaseTableColumn<String>(name: "status")
            let isRoot = DatabaseTableColumn<Bool>(name: "is_root")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }

    }
}
