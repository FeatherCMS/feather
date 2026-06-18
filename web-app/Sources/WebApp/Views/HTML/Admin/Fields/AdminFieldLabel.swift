import CSS
import HTML
import SGML
import WebStandards

struct AdminFieldLabel: Component, FlowContent {
    let label: String
    let required: Bool

    func selectors() -> [any Selector] {
        Class("field-label") {
            Color(.variable("cms-strong-font"))
        }
        Custom("label .field-label") {
            Color(.variable("cms-strong-font"))
        }
        Class("field-label__required") {
            Color(.variable("cms-light-font"))
        }
        Custom("label .field-label__required") {
            Color(.variable("cms-light-font"))
        }
    }

    func content() -> some BasicTag {
        Span {
            InlineText(label)
            if required {
                Span(" (required)")
                    .class("field-label__required")
            }
        }
        .class("field-label")
    }
}
