import AccountModule
import FeatherDBAL
import FeatherInfrastructure
import Foundation

extension Settings {
    enum Table: DatabaseTable {
        static let name = "account_settings"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let userId = DatabaseTableColumn<String>(name: "user_id")
            let language = DatabaseTableColumn<String>(name: "language")
            let timezone = DatabaseTableColumn<String>(name: "timezone")
            let pageSize = DatabaseTableColumn<Int>(name: "page_size")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
