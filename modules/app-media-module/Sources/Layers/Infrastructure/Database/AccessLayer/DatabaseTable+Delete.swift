public import FeatherDBAL

extension MediaAssetNodeTable: DatabaseTableWithDelete {
    struct Columns: DatabaseTableColumns {
        let id = DatabaseTableColumn<String>(name: "id")
    }

    static let columns = Columns()
}

extension MediaVariantProcessorTable: DatabaseTableWithDelete {
    struct Columns: DatabaseTableColumns {
        let id = DatabaseTableColumn<String>(name: "id")
    }

    static let columns = Columns()
}

extension MediaVariantTable: DatabaseTableWithDelete {
    struct Columns: DatabaseTableColumns {
        let id = DatabaseTableColumn<String>(name: "id")
    }

    static let columns = Columns()
}

