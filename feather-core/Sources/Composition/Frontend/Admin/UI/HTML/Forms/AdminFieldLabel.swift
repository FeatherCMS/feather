import CSS
import HTML
import SGML
import WebStandards

public struct AdminFieldLabel: Component, FlowContent {
    public let label: String
    public let required: Bool

    public init(label: String, required: Bool) {
        self.label = label
        self.required = required
    }

    public func selectors() -> [any Selector] {
        Class("field-label") {
            Color(.variable("cms-strong-font"))
        }
        Custom("label .field-label") {
            Color(.variable("cms-strong-font"))
        }
        Class("field-label__optional") {
            Color(.variable("cms-light-font"))
        }
        Custom("label .field-label__optional") {
            Color(.variable("cms-light-font"))
        }
    }

    public func content() -> some BasicTag {
        Span {
            InlineText(label)
            if !required {
                Span(" (Optional)")
                    .class("field-label__optional")
            }
        }
        .class("field-label")
    }
}
