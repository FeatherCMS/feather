public import FeatherDBAL
import FeatherInfrastructure
public import Foundation

public enum IdentityRole {
    public struct Table: DatabaseTable {
        public static let name = "user_identity_role"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let roleId = DatabaseTableColumn<String>(name: "role_id")
            public let identityId = DatabaseTableColumn<String>(
                name: "identity_id"
            )
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
