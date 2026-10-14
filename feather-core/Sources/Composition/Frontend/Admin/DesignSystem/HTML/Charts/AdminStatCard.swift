public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminStatCard: Component {
    public let label: String
    public let value: String

    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }

    public func rules() -> [any Rule] {
        Media {
            Custom(".new-admin-stat-card") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
                Padding(16.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                BorderRadius(12.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            }
            Custom(".new-admin-stat-card__label") {
                Margin(0)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.86.rem)
            }
            Custom(".new-admin-stat-card__value") {
                Margin(0)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                FontSize(1.4.rem)
                FontWeight(.number(650))
            }
        }
    }

    public func html(context: inout BuilderContext) -> Div {
        Div {
            P(label).class("new-admin-stat-card__label")
            Strong(value).class("new-admin-stat-card__value")
        }
        .class("new-admin-stat-card")
    }
}
