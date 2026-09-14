import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminChartCard<Chart: Component>: Component {
    public let title: String
    public let chart: Chart

    public init(title: String, chart: Chart) {
        self.title = title
        self.chart = chart
    }

    public func rules() -> [any Rule] {
        Media {
            Custom(".new-admin-chart-card") {
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
            Custom(".new-admin-chart-card h2, .new-admin-chart-card h3") {
                Margin(0)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            }
        }
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            H2(title)
            context.render(chart)
        }
        .class("new-admin-chart-card")
    }
}
