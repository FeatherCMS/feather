public import FeatherDBAL

extension ArticleTable: DatabaseTableWithDelete {
    struct Columns: DatabaseTableColumns {
        let id = DatabaseTableColumn<String>(name: "id")
    }

    static let columns = Columns()
}

extension CategoryTable: DatabaseTableWithDelete {
    struct Columns: DatabaseTableColumns {
        let id = DatabaseTableColumn<String>(name: "id")
    }

    static let columns = Columns()
}

