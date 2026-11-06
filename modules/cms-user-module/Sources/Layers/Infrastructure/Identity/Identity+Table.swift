public import FeatherDBAL
import FeatherInfrastructure
public import Foundation
public import UserModule

extension Identity {
    public struct Table: DatabaseTable {
        public static let name = "user_identity"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let id = DatabaseTableColumn<String>(name: "id")
            public let name = DatabaseTableColumn<String>(name: "name")
            public let status = DatabaseTableColumn<String>(name: "status")
            public let isRoot = DatabaseTableColumn<Bool>(name: "is_root")
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }

    }
}
