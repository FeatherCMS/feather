public import FeatherDBAL
import FeatherInfrastructure
public import Foundation
public import UserModule

extension Role {
    public struct Table: DatabaseTable {
        public static let name = "user_role"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let id = DatabaseTableColumn<String>(name: "id")
            public let key = DatabaseTableColumn<String>(name: "key")
            public let name = DatabaseTableColumn<String?>(name: "name")
            public let notes = DatabaseTableColumn<String?>(name: "notes")
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
