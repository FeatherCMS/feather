import CSS
import HTML
import SGML
import WebStandards

public struct AdminDetailsField: Component, FlowContent {
    public let label: String
    public let value: String

    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }

    public func selectors() -> [any Selector] {
        for selector in AdminDetailFieldStyles.selectors() {
            selector
        }
    }

    public func content() -> some BasicTag {
        Div {
            P(label)
                .class("admin-details-field__label")
            P(value)
                .class("admin-details-field__value")
        }
        .class("admin-details-field")
    }
}
