import HTML
import SGML
import WebStandards

public struct ListTableShell<Table: FlowContent>: Component, FlowContent {

    public let table: Table

    public init(table: Table) {
        self.table = table
    }

    public func content() -> some BasicTag {
        Div {
            Div {
                table
            }
            .class("table-wrap")
        }
        .class("table-shell")
    }
}
