public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminFormFieldLabel: Component {
    public let text: String
    public let isRequired: Bool

    public init(text: String, isRequired: Bool = true) {
        self.text = text
        self.isRequired = isRequired
    }

    public func selectors() -> [any Selector] {
        [
            Class("new-admin-form-field-label") {
                Display(.inlineFlex)
                AlignItems(.baseline)
                Gap(4.px)
                FontWeight(.normal)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            },
            Class("new-admin-form-field-label__optional") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Span {
        Span {
            Span(text)
            if !isRequired {
                Span("(optional)")
                    .class("new-admin-form-field-label__optional")
            }
        }
        .class("new-admin-form-field-label")
    }
}
