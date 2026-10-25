public import FeatherDBAL

extension IdentityRole.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let roleId: String
        public let identityId: String

        enum CodingKeys: String, CodingKey {
            case roleId = "role_id"
            case identityId = "identity_id"
        }
    }
}

extension IdentityRole.Table: DatabaseTableWithDelete {}

extension IdentityRole.Table {
    struct RoleID: DatabaseTableRowDecodable {
        let roleId: String

        enum CodingKeys: String, CodingKey {
            case roleId = "role_id"
        }
    }

    struct IdentityID: DatabaseTableRowDecodable {
        let identityId: String

        enum CodingKeys: String, CodingKey {
            case identityId = "identity_id"
        }
    }
}
