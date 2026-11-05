public import ContactModule
public import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure

extension FormFieldAssignment {
    public struct Table: DatabaseTable, DatabaseTableWithDelete {
        public static let name = "contact_form_form_field"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let formId = DatabaseTableColumn<String>(name: "form_id")
            public let fieldId = DatabaseTableColumn<String>(name: "field_id")
            public let position = DatabaseTableColumn<Int>(name: "position")
        }

        let connection: any DatabaseConnection
        let context: DatabaseTransactionContext

        init(
            connection: any DatabaseConnection,
            context: DatabaseTransactionContext
        ) {
            self.connection = connection
            self.context = context
        }
    }
}
