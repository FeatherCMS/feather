import CSS
import HTML
import SGML
import WebStandards

struct AdminDetailsField: Component, FlowContent {
    let label: String
    let value: String

    func selectors() -> [any Selector] {
        for selector in AdminDetailFieldStyles.selectors() {
            selector
        }
    }

    func content() -> some BasicTag {
        Div {
            P(label)
                .class("admin-details-field__label")
            P(value)
                .class("admin-details-field__value")
        }
        .class("admin-details-field")
    }
}
