public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminChartCard<Chart: Component>: Component {
    public let title: String
    public let chart: Chart

    public init(title: String, chart: Chart) {
        self.title = title
        self.chart = chart
    }

    public func rules() -> [any Rule] {
        Media {
            Custom(".admin-chart-card") {
                Display(.flex)
                FlexDirection(.column)
                Gap(16.px)
                Padding(16.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                BorderRadius(12.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            }
            Custom(".admin-chart-card h2, .admin-chart-card h3") {
                Margin(0)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            }
        }
    }

    public func html(context: inout BuilderContext) -> Div {
        Div {
            H2(title)
            context.build(chart)
        }
        .class("admin-chart-card")
    }
}
