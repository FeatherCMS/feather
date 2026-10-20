import FeatherDBAL
import UserModule

extension Identity.Table: DatabaseTableWithDelete {
    struct Columns: DatabaseTableColumns {
        let id = DatabaseTableColumn<String>(name: "id")
    }

    static let columns = Identity.Table.Columns()
}

extension Role.Table: DatabaseTableWithDelete {
    struct Columns: DatabaseTableColumns {
        let id = DatabaseTableColumn<String>(name: "id")
    }

    static let columns = Role.Table.Columns()
}
