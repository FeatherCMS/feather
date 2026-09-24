public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminDetailField: Component {
    public let label: String
    public let value: String

    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("new-admin-detail-field") {
                Padding(vertical: 12.px)
            },
            Class("new-admin-detail-field__label") {
                Margin(0)
                Padding(bottom: 8.px)
                BorderBottom(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Opacity(0.8)
            },
            Class("new-admin-detail-field__value") {
                Margin(top: 6.px)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                OverflowWrap(.anywhere)
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Div {
        Div {
            P(label).class("new-admin-detail-field__label")
            P(value).class("new-admin-detail-field__value")
        }
        .class("new-admin-detail-field")
    }
}
