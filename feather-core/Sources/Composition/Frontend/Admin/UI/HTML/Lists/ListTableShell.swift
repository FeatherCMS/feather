import HTML
import SGML
import WebComponents
import WebBuilders

public struct ListTableShell<Table: FlowContent>: Leaf {

    public let table: Table

    public init(table: Table) {
        self.table = table
    }

    public func renderHTML() -> Div {
        Div {
            Div {
                table
            }
            .class("table-wrap")
        }
        .class("table-shell")
    }
}
