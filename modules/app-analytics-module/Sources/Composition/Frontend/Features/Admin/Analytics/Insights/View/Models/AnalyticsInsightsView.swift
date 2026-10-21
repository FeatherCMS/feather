import AnalyticsAdminAPI
import CSS
import FeatherAdmin
import Foundation
import HTML
import SGML
import WebBuilders
import WebComponents

struct AnalyticsInsightsView: Component {
    let page: AdminAnalyticsInsightsPage

    func rules() -> [any Rule] {
        Media {
            Custom(".analytics-insights") {
                Display(.grid)
                Gap(40.px)
            }
            Custom(".analytics-insights__intro") {
                Display(.grid)
                Gap(12.px)
                MinWidth(0.px)
            }
            Custom(".analytics-insights__section-heading") {
                Display(.flex)
                AlignItems(.center)
                Gap(14.px)
                Margin(left: 8.px)
            }
            Custom(".analytics-insights__section") {
                Display(.grid)
                Gap(18.px)
                MinWidth(0.px)
            }
            Custom(".analytics-insights__section-heading-copy") {
                Display(.grid)
                Gap(6.px)
                MinWidth(0.px)
            }
            Custom(".analytics-insights__section-icon") {
                Width(30.px)
                Height(30.px)
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.center)
                FlexShrink(0)
                Color(.variable(TokenKey.Colors.Accents.Secondary.tint))
            }
            Custom(".analytics-insights__section-icon svg") {
                Width(30.px)
                Height(30.px)
            }
            Custom(".analytics-insights__section-heading h2") {
                Margin(0)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                FontSize(1.15.rem)
            }
            Custom(".analytics-insights__section-heading p") {
                Margin(0)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Opacity(0.78)
                FontSize(0.92.rem)
            }
            Custom(".analytics-insights__stats") {
                Display(.grid)
                GridTemplateColumns(.repeat(3, .fraction(1.fr)))
                Gap(18.px)
                MinWidth(0.px)
            }
            Custom(".analytics-insights__stats .new-admin-stat-card") {
                MinHeight(108.px)
                BoxSizing(.borderBox)
                JustifyContent(.center)
                Padding(22.px)
                BorderRadius(16.px)
            }
            Custom(".analytics-insights__stats .new-admin-stat-card__label") {
                FontSize(0.78.rem)
                FontWeight(.number(600))
                LetterSpacing(0.045.em)
                TextTransform(.uppercase)
            }
            Custom(".analytics-insights__stats .new-admin-stat-card__value") {
                FontSize(1.75.rem)
            }
            Custom(".analytics-insights__breakdowns") {
                Display(.grid)
                GridTemplateColumns(.repeat(3, .fraction(1.fr)))
                Gap(24.px)
                MinWidth(0.px)
            }
            Custom(".analytics-insights .new-admin-chart-card") {
                Gap(20.px)
                Padding(24.px)
                BorderRadius(18.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                MinWidth(0.px)
                BoxSizing(.borderBox)
            }
            Custom(
                ".analytics-insights .new-admin-chart-card svg > rect:first-child"
            ) {
                UnsafeRawProperty(
                    name: "fill",
                    value: "var(--material-color-secondary-tint)"
                )
            }
            Custom(".analytics-insights .new-admin-chart-card h2") {
                FontSize(1.rem)
                FontWeight(.number(650))
                Padding(bottom: 14.px)
                BorderBottom(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
            }
            Custom(".analytics-insights .new-admin-bar-chart") {
                Gap(14.px)
            }
            Custom(".analytics-insights .new-admin-bar-chart__row") {
                Gap(8.px)
            }
            Custom(".analytics-insights .new-admin-bar-chart__track") {
                Height(12.px)
            }
            Custom(
                ".analytics-insights .breadcrumb, "
                    + ".analytics-insights .admin-page-header, "
                    + ".analytics-insights .new-admin-form"
            ) {
                MarginTop(0.px)
                MarginBottom(0.px)
            }
        }
        Media(.maxWidth(850.px)) {
            Custom(".analytics-insights__breakdowns") {
                GridTemplateColumns(.repeat(2, .fraction(1.fr)))
            }
            Custom(".analytics-insights__stats") {
                GridTemplateColumns(.repeat(2, .fraction(1.fr)))
            }
        }
        Media(.maxWidth(600.px)) {
            Custom(
                ".analytics-insights__breakdowns, .analytics-insights__stats"
            ) {
                GridTemplateColumns(.fraction(1.fr))
            }
            Custom(".analytics-insights .new-admin-chart-card") {
                Padding(18.px)
            }
        }
    }

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            Div {
                context.build(NewAdminBreadcrumb(links: breadcrumb))
                context.build(
                    NewAdminPageHeader(
                        state: .primary(
                            title: page.source.pageTitle,
                            description: page.source.summary
                        )
                    )
                )
                context.build(
                    AnalyticsDateRangeFilter(
                        state: .init(
                            action: page.source.pagePath,
                            from: page.from,
                            to: page.to,
                            queryItems: []
                        )
                    )
                )
            }
            .class("analytics-insights__intro")
            Div {
                sectionHeading(
                    icon: "activity",
                    title: "Traffic summary",
                    description: page.source == .web
                        ? "Key metrics for this range. Unique visitors are estimated from signed-in accounts or anonymous IP/browser signatures."
                        : "Key request metrics for the selected range."
                )
                Div {
                    for item in metrics {
                        context.build(
                            NewAdminStatCard(label: item.0, value: item.1)
                        )
                    }
                }
                .class("analytics-insights__stats")
            }
            .class("analytics-insights__section")
            Div {
                sectionHeading(
                    icon: "trendingUp",
                    title: "Traffic",
                    description:
                        page.source == .web
                        ? "Human page views across the selected time range."
                        : "Logged API events across the selected time range."
                )
                context.build(
                    NewAdminChartCard(
                        title: page.source == .web
                            ? "Daily page views" : "Daily API events",
                        chart: NewAdminLineChart(
                            points: page.overview.daily.map {
                                .init(
                                    label: dateLabel(for: $0.bucket),
                                    value: $0.requests
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
            .class("analytics-insights__section")
            Div {
                sectionHeading(
                    icon: "barChart2",
                    title: "Breakdowns",
                    description:
                        page.source == .web
                        ? "Explore pages, referrers, and audience characteristics."
                        : "Explore requests by path, method, and response status."
                )
                Div {
                    for card in breakdowns {
                        context.build(card)
                    }
                }
                .class("analytics-insights__breakdowns")
            }
            .class("analytics-insights__section")
        }
        .class("analytics-insights")
    }

    private var breadcrumb: [NewAdminBreadcrumb.Link] {
        AnalyticsAdminRoutes.breadcrumb
    }

    private func sectionHeading(
        icon name: String,
        title: String,
        description: String
    ) -> Div {
        Div {
            if let icon = FeatherIcons.get(named: name) {
                Div { icon }
                    .class("analytics-insights__section-icon")
            }
            Div {
                H2(title)
                P(description)
            }
            .class("analytics-insights__section-heading-copy")
        }
        .class("analytics-insights__section-heading")
    }

    private var metrics: [(String, String)] {
        let kpis = page.overview.kpis
        if page.source == .web {
            return [
                (
                    "Tracked web events",
                    kpis.totalRequests.formatted(.number.grouping(.automatic))
                ),
                (
                    "Events/day",
                    kpis.averageRequestsPerDay.formatted(
                        .number.grouping(.automatic).precision(
                            .fractionLength(1)
                        )
                    )
                ),
                (
                    "Authenticated requests",
                    kpis.authenticatedRequests.formatted(
                        .number.grouping(.automatic)
                    )
                ),
                (
                    "Estimated unique visitors",
                    kpis.uniqueVisitors.formatted(.number.grouping(.automatic))
                ),
                ("Page views", kpis.pageViews.formatted(.number.grouping(.automatic))),
                (
                    "POST requests",
                    kpis.searchRequests.formatted(.number.grouping(.automatic))
                ),
                (
                    "Human requests (estimated)",
                    kpis.humanRequests.formatted(.number.grouping(.automatic))
                ),
                (
                    "Bot requests",
                    kpis.botRequests.formatted(.number.grouping(.automatic))
                ),
                ("AI requests", kpis.aiRequests.formatted(.number.grouping(.automatic))),
                ("404s", kpis.notFoundRequests.formatted(.number.grouping(.automatic))),
                ("4xx", kpis.clientErrorRequests.formatted(.number.grouping(.automatic))),
                ("5xx", kpis.serverErrorRequests.formatted(.number.grouping(.automatic))),
            ]
        }
        return [
            (
                "Logged API events",
                kpis.totalRequests.formatted(.number.grouping(.automatic))
            ),
            (
                "Events/day",
                kpis.averageRequestsPerDay.formatted(
                        .number.grouping(.automatic).precision(
                            .fractionLength(1)
                        )
                )
            ),
            (
                "Non-error events (logged)",
                successRate.formatted(
                    .number.grouping(.automatic).precision(.fractionLength(1))
                )
                    + "%"
            ),
            (
                "Error events (logged)",
                errorRate.formatted(
                    .number.grouping(.automatic).precision(.fractionLength(1))
                ) + "%"
            ),
            (
                "4xx errors",
                kpis.clientErrorRequests.formatted(.number.grouping(.automatic))
            ),
            (
                "5xx errors",
                kpis.serverErrorRequests.formatted(.number.grouping(.automatic))
            ),
        ]
    }

    private var breakdowns: [NewAdminChartCard<NewAdminBarChart>] {
        let overview = page.overview
        if page.source == .web {
            return [
                breakdown("Top pages", overview.paths),
                breakdown("Referrers", overview.referrers),
                trafficTypeBreakdown,
                breakdown("Operating systems", overview.operatingSystems),
                breakdown("Browsers", overview.browsers),
                breakdown("Device types", overview.deviceTypes),
                breakdown("Languages", overview.languages),
                breakdown("Language regions", overview.regions),
                breakdown("5xx paths", overview.serverErrorPaths),
            ]
        }
        return [
            breakdown("Top paths", overview.paths),
            breakdown("Methods", overview.methods),
            breakdown("5xx paths", overview.serverErrorPaths),
        ]
    }

    private func breakdown(
        _ title: String,
        _ items: [AnalyticsAdminAPI.Components.Schemas
            .AnalyticsLogOverviewBreakdownItemSchema]
    ) -> NewAdminChartCard<NewAdminBarChart> {
        NewAdminChartCard(
            title: title,
            chart: NewAdminBarChart(
                items: items.map {
                    .init(label: $0.label, value: $0.count, share: $0.share)
                }
            )
        )
    }

    private var trafficTypeBreakdown: NewAdminChartCard<NewAdminBarChart> {
        let kpis = page.overview.kpis
        let trackedRequests = max(0, kpis.totalRequests)
        let humans = min(max(0, kpis.humanRequests), trackedRequests)
        let bots = min(max(0, kpis.botRequests), trackedRequests - humans)
        let ai = min(max(0, kpis.aiRequests), trackedRequests - humans - bots)
        let humanShare =
            trackedRequests > 0
            ? Double(humans) / Double(trackedRequests)
            : 0
        let botShare =
            trackedRequests > 0
            ? Double(bots) / Double(trackedRequests)
            : 0
        let aiShare =
            trackedRequests > 0
            ? Double(ai) / Double(trackedRequests)
            : 0

        return NewAdminChartCard(
            title: "Traffic by type (estimated from User-Agent)",
            chart: NewAdminBarChart(
                items: [
                    .init(
                        label: "Human / unrecognized",
                        value: humans,
                        share: humanShare
                    ),
                    .init(
                        label: "AI",
                        value: ai,
                        share: aiShare
                    ),
                    .init(
                        label: "Bot",
                        value: bots,
                        share: botShare
                    ),
                ]
            )
        )
    }

    private var successRate: Double {
        let total = Double(page.overview.kpis.totalRequests)
        guard total > 0 else { return 0 }
        let errors = Double(
            page.overview.kpis.clientErrorRequests
                + page.overview.kpis.serverErrorRequests
        )
        return ((total - errors) / total) * 100
    }

    private var errorRate: Double { 100 - successRate }

    private func dateLabel(for timestamp: Double) -> String {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat =
            page.overview.query.to - page.overview.query.from <= 86_400
            ? "HH:mm"
            : "MMM d"
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
