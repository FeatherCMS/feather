public import FeatherDBAL

extension IdentityRole.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let roleId: String
        public let identityId: String
    }
}

extension IdentityRole.Table: DatabaseTableWithDelete {}

extension IdentityRole.Table {
    struct RoleID: DatabaseTableRowDecodable {
        let roleId: String
    }

    struct IdentityID: DatabaseTableRowDecodable {
        let identityId: String
    }
}
