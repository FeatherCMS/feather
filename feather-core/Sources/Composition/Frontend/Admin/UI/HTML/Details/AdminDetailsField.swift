import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct AdminDetailsField: Component {
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

    public func html(context: inout RenderContext) -> Div {
        Div {
            P(label)
                .class("admin-details-field__label")
            P(value)
                .class("admin-details-field__value")
        }
        .class("admin-details-field")
    }
}
