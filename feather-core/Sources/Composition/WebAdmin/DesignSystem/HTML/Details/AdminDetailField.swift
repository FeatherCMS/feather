public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminDetailField: Component {
    public let label: String
    public let value: String
    private var isRemovalLabel = false

    public init(
        label: String,
        value: String
    ) {
        self.label = label
        self.value = value
    }

    public func setAsRemoveConfirmationLabel(_ condition: Bool = true) -> Self {
        var field = self
        field.isRemovalLabel = condition
        return field
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("admin-detail-field") {
                Padding(vertical: 12.px)
            },
            Class("admin-detail-field__label") {
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
            Class("admin-detail-field__value") {
                Margin(top: 6.px)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                OverflowWrap(.anywhere)
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Div {
        Div {
            P(label).class("admin-detail-field__label")
            let valueView = P(value).class("admin-detail-field__value")
            if isRemovalLabel {
                valueView.setAsRemoveConfirmationLabel()
            }
            else {
                valueView
            }
        }
        .class("admin-detail-field")
    }
}
