import HTML
import SGML
import WebBuilders
import WebComponents

@available(*, deprecated, message: "Use the new admin list components instead.")
public struct ListTableShell<Table: FlowContent>: Component {

    public let table: Table

    public init(table: Table) {
        self.table = table
    }

    public func html(context: inout BuilderContext) -> Div {
        Div {
            Div {
                table
            }
            .class("table-wrap")
        }
        .class("table-shell")
    }
}
