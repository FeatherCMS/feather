public import FeatherDBAL

extension IdentityTable: DatabaseTableWithDelete {
    struct Columns: DatabaseTableColumns {
        let id = DatabaseTableColumn<String>(name: "id")
    }

    static let columns = Columns()
}

extension RoleTable: DatabaseTableWithDelete {
    struct Columns: DatabaseTableColumns {
        let id = DatabaseTableColumn<String>(name: "id")
    }

    static let columns = Columns()
}

