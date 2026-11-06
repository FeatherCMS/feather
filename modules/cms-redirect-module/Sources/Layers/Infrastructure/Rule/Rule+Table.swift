import FeatherDBAL
import Foundation
import RedirectModule

extension Rule {
    struct Table: DatabaseTable {
        static let name = "redirect_rule"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let source = DatabaseTableColumn<String>(name: "source")
            let destination = DatabaseTableColumn<String>(name: "destination")
            let statusCode = DatabaseTableColumn<Int>(name: "status_code")
            let notes = DatabaseTableColumn<String?>(name: "notes")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
