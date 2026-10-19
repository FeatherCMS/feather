public import FeatherDBAL

extension AuthEmailTable: DatabaseTableWithDelete {
    struct Columns: DatabaseTableColumns {
        let id = DatabaseTableColumn<String>(name: "id")
    }

    static let columns = Columns()
}

extension CredentialTable: DatabaseTableWithDelete {
    public struct Columns: DatabaseTableColumns {
        public let id = DatabaseTableColumn<String>(name: "id")
    }

    public static let columns = Columns()
}

extension MagicLinkTable: DatabaseTableWithDelete {
    struct Columns: DatabaseTableColumns {
        let id = DatabaseTableColumn<String>(name: "id")
    }

    static let columns = Columns()
}

extension SessionTable: DatabaseTableWithDelete {
    struct Columns: DatabaseTableColumns {
        let id = DatabaseTableColumn<String>(name: "id")
    }

    static let columns = Columns()
}

