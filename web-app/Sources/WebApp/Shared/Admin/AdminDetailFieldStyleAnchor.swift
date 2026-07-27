import CSS
import HTML
import SGML
import WebStandards

struct AdminDetailFieldStyleAnchor: Component, FlowContent {

    func selectors() -> [any Selector] {
        AdminDetailFieldStyles.selectors()
    }

    func content() -> some BasicTag {
        Div {}.hidden()
    }
}
