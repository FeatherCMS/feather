public import ContactModule
public import FeatherDBAL

public import struct Foundation.Date

extension FormField {
    public struct Table: DatabaseTable {
        public static let name = "contact_form_field"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let id = DatabaseTableColumn<String>(name: "id")
            public let key = DatabaseTableColumn<String>(name: "key")
            public let type = DatabaseTableColumn<String>(name: "type")
            public let label = DatabaseTableColumn<String>(name: "label")
            public let allowedValues = DatabaseTableColumn<String>(
                name: "allowed_values"
            )
            public let isRequired = DatabaseTableColumn<Bool>(
                name: "is_required"
            )
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
