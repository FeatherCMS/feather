import HTML
import SGML
import WebStandards

struct ListTableShell<Table: FlowContent>: Component, FlowContent {

    let table: Table

    func content() -> some BasicTag {
        Div {
            Div {
                table
            }
            .class("table-wrap")
        }
        .class("table-shell")
    }
}
