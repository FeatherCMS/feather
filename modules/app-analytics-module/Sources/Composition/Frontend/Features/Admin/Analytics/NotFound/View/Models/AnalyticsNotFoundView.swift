import AnalyticsAdminAPI
import CSS
import FeatherAdmin
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AnalyticsNotFoundView: Component {
    let model: AdminViewAnalyticsNotFoundModel

    func rules() -> [any Rule] {
        Media {
            Custom(".analytics-not-found") {
                Display(.grid)
                Gap(40.px)
            }
            Custom(".analytics-not-found__intro") {
                Display(.grid)
                Gap(12.px)
                MinWidth(0.px)
            }
            Custom(".analytics-not-found__section") {
                Display(.grid)
                Gap(18.px)
                MinWidth(0.px)
            }
            Custom(".analytics-not-found__section-heading") {
                Display(.flex)
                AlignItems(.center)
                Gap(14.px)
                Margin(left: 8.px)
            }
            Custom(".analytics-not-found__section-heading-copy") {
                Display(.grid)
                Gap(6.px)
                MinWidth(0.px)
            }
            Custom(".analytics-not-found__section-icon") {
                Width(30.px)
                Height(30.px)
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.center)
                FlexShrink(0)
                Color(.variable(TokenKey.Colors.Accents.Secondary.tint))
            }
            Custom(".analytics-not-found__section-icon svg") {
                Width(30.px)
                Height(30.px)
            }
            Custom(".analytics-not-found__section-heading h2") {
                Margin(0)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                FontSize(1.15.rem)
            }
            Custom(".analytics-not-found__section-heading p") {
                Margin(0)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Opacity(0.78)
                FontSize(0.92.rem)
            }
            Custom(".analytics-not-found .new-admin-chart-card") {
                Gap(20.px)
                Padding(24.px)
                BorderRadius(18.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                MinWidth(0.px)
                BoxSizing(.borderBox)
            }
            Custom(
                ".analytics-not-found .new-admin-chart-card svg > rect:first-child"
            ) {
                UnsafeRawProperty(
                    name: "fill",
                    value: "var(--material-color-secondary-tint)"
                )
            }
            Custom(".analytics-not-found .new-admin-chart-card h2") {
                FontSize(1.rem)
                FontWeight(.number(650))
                Padding(bottom: 14.px)
                BorderBottom(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
            }
            Custom(".analytics-not-found .new-admin-bar-chart") {
                Gap(14.px)
            }
            Custom(".analytics-not-found .new-admin-bar-chart__row") {
                Gap(8.px)
            }
            Custom(".analytics-not-found .new-admin-bar-chart__track") {
                Height(12.px)
            }
            Custom(
                ".analytics-not-found .breadcrumb, "
                    + ".analytics-not-found .admin-page-header, "
                    + ".analytics-not-found .new-admin-form"
            ) {
                MarginTop(0.px)
                MarginBottom(0.px)
            }
        }
        Media(.maxWidth(600.px)) {
            Custom(".analytics-not-found .new-admin-chart-card") {
                Padding(18.px)
            }
        }
    }

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            Div {
                context.build(
                    NewAdminBreadcrumb(links: AnalyticsAdminRoutes.breadcrumb)
                )
                context.build(
                    NewAdminPageHeader(
                        state: .init(
                            title: model.title,
                            description: model.description
                        )
                    )
                )
                context.build(
                    AnalyticsDateRangeFilter(
                        state: .init(
                            action: AnalyticsAdminRoutes.notFound.description,
                            from: model.from,
                            to: model.to,
                            queryItems: []
                        )
                    )
                )
            }
            .class("analytics-not-found__intro")
            Div {
                sectionHeading(
                    icon: "trendingUp",
                    title: "Traffic",
                    description: "404 requests across the selected time range."
                )
                context.build(
                    NewAdminChartCard(
                        title: "Daily 404s",
                        chart: NewAdminLineChart(
                            points: model.overview.daily.map {
                                .init(
                                    label: dateLabel(for: $0.bucket),
                                    value: $0.notFoundRequests
                                )
                            },
                            leftInset: 0,
                            rightInset: 0,
                            topInset: 0,
                            bottomInset: 0
                        )
                    )
                )
            }
            .class("analytics-not-found__section")
            Div {
                sectionHeading(
                    icon: "barChart2",
                    title: "Breakdowns",
                    description: "Routes visitors could not find in this range."
                )
                context.build(
                    NewAdminChartCard(
                        title: "404 pages",
                        chart: NewAdminBarChart(
                            items: model.overview.notFoundPaths.map {
                                .init(
                                    label: $0.label,
                                    value: $0.count,
                                    share: $0.share
                                )
                            }
                        )
                    )
                )
            }
            .class("analytics-not-found__section")
        }
        .class("analytics-not-found")
    }

    private func sectionHeading(
        icon name: String,
        title: String,
        description: String
    ) -> Div {
        Div {
            if let icon = FeatherIcons.get(named: name) {
                Div { icon }
                    .class("analytics-not-found__section-icon")
            }
            Div {
                H2(title)
                P(description)
            }
            .class("analytics-not-found__section-heading-copy")
        }
        .class("analytics-not-found__section-heading")
    }

    private func dateLabel(for timestamp: Double) -> String {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat =
            model.overview.query.to - model.overview.query.from <= 86_400
            ? "HH:mm"
            : "MMM d"
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
