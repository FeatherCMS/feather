import FeatherDBAL

extension IdentityRole.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let roleId: String
        let identityId: String
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
