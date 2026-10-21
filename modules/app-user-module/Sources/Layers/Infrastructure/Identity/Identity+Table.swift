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

        struct Row: DatabaseTableRowDecodable {
            let id: String
            let name: String
            let status: String
            let isRoot: Bool
            let createdAt: Date
            let updatedAt: Date
        }

        struct RoleLink: DatabaseTable {
            static let name = "user_identity_role"
            static let columns = Columns()

            struct Columns: DatabaseTableColumns {
                let roleId = DatabaseTableColumn<String>(name: "role_id")
                let identityId = DatabaseTableColumn<String>(
                    name: "identity_id"
                )
            }

            struct Row: DatabaseTableRowDecodable {
                let roleId: String
                let identityId: String
            }

            struct RoleID: DatabaseTableRowDecodable {
                let roleId: String
            }

            struct IdentityID: DatabaseTableRowDecodable {
                let identityId: String
            }

        }

    }
}
