import CSS
import HTML
import SGML
import WebStandards

struct AdminDetailFieldStyleAnchor: Component, FlowContent {

    func selectors() -> [any Selector] {
        for selector in AdminDetailFieldStyles.selectors() {
            selector
        }
    }

    func content() -> some BasicTag {
        Div {}.hidden()
    }
}
