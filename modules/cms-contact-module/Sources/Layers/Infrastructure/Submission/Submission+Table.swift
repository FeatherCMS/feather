public import ContactModule
public import FeatherDBAL

public import struct Foundation.Date

extension Submission {
    public struct Table: DatabaseTable {
        public static let name = "contact_form_submission"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let id = DatabaseTableColumn<String>(name: "id")
            public let formId = DatabaseTableColumn<String>(name: "form_id")
            public let values = DatabaseTableColumn<String>(name: "values")
            public let itemsSnapshot = DatabaseTableColumn<String>(
                name: "items_snapshot"
            )
            public let metadata = DatabaseTableColumn<String?>(name: "metadata")
            public let status = DatabaseTableColumn<String>(name: "status")
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
