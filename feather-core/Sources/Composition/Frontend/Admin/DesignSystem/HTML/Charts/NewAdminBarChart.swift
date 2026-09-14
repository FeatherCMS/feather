import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminBarChart: Component {
    public struct Item: Sendable {
        public let label: String
        public let value: Int
        public let share: Double?

        public init(label: String, value: Int, share: Double? = nil) {
            self.label = label
            self.value = value
            self.share = share
        }
    }

    public let items: [Item]
    public let color: String
    public let limit: Int

    public init(
        items: [Item],
        color: String = "var(--accent-color-primary-hover)",
        limit: Int = 8
    ) {
        self.items = items
        self.color = color
        self.limit = limit
    }

    public func rules() -> [any Rule] {
        Media {
            Custom(".new-admin-bar-chart") {
                Display(.flex)
                FlexDirection(.column)
                Gap(12.px)
            }
            Custom(".new-admin-bar-chart__row") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
            }
            Custom(".new-admin-bar-chart__header") {
                Display(.flex)
                AlignItems(.baseline)
                JustifyContent(.spaceBetween)
                Gap(12.px)
            }
            Custom(".new-admin-bar-chart__label") {
                MinWidth(0.px)
                Overflow(.hidden)
                TextOverflow(.ellipsis)
                WhiteSpace(.nowrap)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            }
            Custom(".new-admin-bar-chart__value") {
                FlexShrink(0)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            }
            Custom(".new-admin-bar-chart__track") {
                Height(10.px)
                BorderRadius(999.px)
                Overflow(.hidden)
                Background(
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
            }
            Custom(".new-admin-bar-chart__bar") {
                Height(100.percent)
                BorderRadius(999.px)
            }
        }
    }

    public func html(context: inout RenderContext) -> Div {
        let visibleItems = Array(items.prefix(limit))
        let maxValue = Double(max(1, visibleItems.map(\.value).max() ?? 1))
        return Div {
            if visibleItems.isEmpty {
                P("No data in this window.")
            }
            else {
                for item in visibleItems {
                    let width = max(
                        3,
                        Int(
                            (item.share ?? (Double(item.value) / maxValue))
                                * 100
                        )
                    )
                    Div {
                        Div {
                            Span(item.label).class("new-admin-bar-chart__label")
                            Span("\(item.value)")
                                .class("new-admin-bar-chart__value")
                        }
                        .class("new-admin-bar-chart__header")
                        Div {
                            Div {}
                                .class("new-admin-bar-chart__bar")
                                .style("width:\(width)%;background:\(color);")
                        }
                        .class("new-admin-bar-chart__track")
                    }
                    .class("new-admin-bar-chart__row")
                }
            }
        }
        .class("new-admin-bar-chart")
    }
}
