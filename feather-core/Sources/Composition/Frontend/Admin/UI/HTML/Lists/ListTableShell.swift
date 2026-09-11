import HTML
import SGML
import WebBuilders
import WebComponents

public struct ListTableShell<Table: FlowContent>: Component {

    public let table: Table

    public init(table: Table) {
        self.table = table
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            Div {
                table
            }
            .class("table-wrap")
        }
        .class("table-shell")
    }
}
