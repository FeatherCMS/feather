import CSS
import HTML
import SGML
import WebComponents
import WebBuilders

public struct AdminFieldLabel: Leaf {
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
        Class("field-label__required") {
            Color(.variable("cms-light-font"))
        }
        Custom("label .field-label__required") {
            Color(.variable("cms-light-font"))
        }
    }

    public func renderHTML() -> Span {
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
