public import ContactModule
public import FeatherDBAL

public import struct Foundation.Date

extension Form {
    public struct Table: DatabaseTable {
        public static let name = "contact_form"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let id = DatabaseTableColumn<String>(name: "id")
            public let key = DatabaseTableColumn<String>(name: "key")
            public let name = DatabaseTableColumn<String>(name: "name")
            public let successMessage = DatabaseTableColumn<String>(
                name: "success_message"
            )
            public let failureMessage = DatabaseTableColumn<String>(
                name: "failure_message"
            )
            public let redirectUrl = DatabaseTableColumn<String?>(
                name: "redirect_url"
            )
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
