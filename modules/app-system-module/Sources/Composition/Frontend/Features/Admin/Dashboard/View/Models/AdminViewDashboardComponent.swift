import CSS
import FeatherAdmin
import Foundation
import HTML
import SGML
import WebBuilders
import WebComponents

struct AdminViewDashboardComponent: Component {
    let model: AdminViewDashboardModel

    func rules() -> [any Rule] {
        Media {
            Custom(".admin-dashboard") {
                Display(.grid)
                Gap(40.px)
            }
            Custom(".admin-dashboard__intro") {
                Display(.grid)
                Gap(12.px)
            }
            Custom(".admin-dashboard__section") {
                Display(.grid)
                Gap(18.px)
                MinWidth(0.px)
            }
            Custom(".admin-dashboard__section-heading") {
                Display(.flex)
                AlignItems(.center)
                Gap(14.px)
                Margin(left: 8.px)
            }
            Custom(".admin-dashboard__section-heading-copy") {
                Display(.grid)
                Gap(6.px)
                MinWidth(0.px)
            }
            Custom(".admin-dashboard__section-icon") {
                Width(30.px)
                Height(30.px)
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.center)
                FlexShrink(0)
                Color(.variable(TokenKey.Colors.Accents.Secondary.tint))
            }
            Custom(".admin-dashboard__section-icon svg") {
                Width(30.px)
                Height(30.px)
            }
            Custom(".admin-dashboard__section-heading h2") {
                Margin(0)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                FontSize(1.15.rem)
            }
            Custom(".admin-dashboard__section-heading p") {
                Margin(0)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Opacity(0.78)
                FontSize(0.92.rem)
            }
            Custom(".admin-dashboard__stats") {
                Display(.grid)
                GridTemplateColumns(.repeat(5, .fraction(1.fr)))
                Gap(18.px)
            }
            Custom(".admin-dashboard__stats .new-admin-stat-card") {
                MinHeight(108.px)
                BoxSizing(.borderBox)
                JustifyContent(.center)
                Padding(22.px)
                BorderRadius(16.px)
            }
            Custom(".admin-dashboard__stats .new-admin-stat-card__label") {
                FontSize(0.78.rem)
                FontWeight(.number(600))
                LetterSpacing(0.045.em)
                TextTransform(.uppercase)
            }
            Custom(".admin-dashboard__stats .new-admin-stat-card__value") {
                FontSize(1.75.rem)
            }
            Custom(".admin-dashboard__primary-grid") {
                Display(.grid)
                GridTemplateColumns(.fraction(1.fr))
                AlignItems(.stretch)
                Gap(24.px)
            }
            Custom(".admin-dashboard__insights-grid") {
                Display(.grid)
                GridTemplateColumns(.repeat(3, .fraction(1.fr)))
                Gap(24.px)
            }
            Custom(".admin-dashboard .new-admin-chart-card") {
                Gap(20.px)
                Padding(24.px)
                BorderRadius(18.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            }
            Custom(
                ".admin-dashboard .new-admin-chart-card svg > rect:first-child"
            ) {
                UnsafeRawProperty(
                    name: "fill",
                    value: "var(--material-color-secondary-tint)"
                )
            }
            Custom(".admin-dashboard .new-admin-chart-card h2") {
                FontSize(1.rem)
                FontWeight(.number(650))
                Padding(bottom: 14.px)
                BorderBottom(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
            }
            Custom(".admin-dashboard .new-admin-bar-chart") {
                Gap(14.px)
            }
            Custom(".admin-dashboard .new-admin-bar-chart__row") {
                Gap(8.px)
            }
            Custom(".admin-dashboard .new-admin-bar-chart__track") {
                Height(12.px)
            }
            Custom(".admin-dashboard__traffic .new-admin-chart-card") {
                Height(100.percent)
                BoxSizing(.borderBox)
            }
            Custom(
                ".admin-dashboard .breadcrumb, "
                    + ".admin-dashboard .admin-page-header"
            ) {
                MarginBottom(0.px)
            }
        }
        Media(.maxWidth(1200.px)) {
            Custom(".admin-dashboard__stats") {
                GridTemplateColumns(.repeat(3, .fraction(1.fr)))
            }
            Custom(".admin-dashboard__insights-grid") {
                GridTemplateColumns(.repeat(2, .fraction(1.fr)))
            }
        }
        Media(.maxWidth(850.px)) {
            Custom(".admin-dashboard__primary-grid") {
                GridTemplateColumns(.fraction(1.fr))
            }
            Custom(".admin-dashboard__insights-grid") {
                GridTemplateColumns(.fraction(1.fr))
            }
            Custom(".admin-dashboard__stats") {
                GridTemplateColumns(.repeat(2, .fraction(1.fr)))
            }
        }
        Media(.maxWidth(460.px)) {
            Custom(".admin-dashboard__stats") {
                GridTemplateColumns(.fraction(1.fr))
            }
        }
    }

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            Div {
                context.build(
                    NewAdminBreadcrumb(
                        links: [.init(label: "Admin", link: "/admin/")]
                    )
                )
                context.build(
                    NewAdminPageHeader(
                        state: .init(
                            title: "Dashboard",
                            description: model.summary
                        )
                    )
                )
            }
            .class("admin-dashboard__intro")
            if !model.contentStats.isEmpty {
                Div {
                    Div {
                        if let icon = FeatherIcons.get(named: "layers") {
                            Div { icon }
                                .class("admin-dashboard__section-icon")
                        }
                        Div {
                            H2("Content at a glance")
                            P(
                                "Your available content across installed modules."
                            )
                        }
                        .class("admin-dashboard__section-heading-copy")
                    }
                    .class("admin-dashboard__section-heading")
                    Div {
                        for item in model.contentStats {
                            context.build(
                                NewAdminStatCard(
                                    label: item.label,
                                    value: item.value
                                )
                            )
                        }
                    }
                    .class("admin-dashboard__stats")
                }
                .class("admin-dashboard__section")
            }
            if model.dailyTraffic != nil {
                Div {
                    Div {
                        if let icon = FeatherIcons.get(named: "activity") {
                            Div { icon }
                                .class("admin-dashboard__section-icon")
                        }
                        Div {
                            H2("Traffic")
                            P("Web activity over the last 7 days.")
                        }
                        .class("admin-dashboard__section-heading-copy")
                    }
                    .class("admin-dashboard__section-heading")
                    Div {
                        if let dailyTraffic = model.dailyTraffic {
                            Div {
                                context.build(
                                    NewAdminChartCard(
                                        title: "Daily traffic",
                                        chart: NewAdminLineChart(
                                            points: dailyTraffic.map {
                                                .init(
                                                    label: dateLabel(
                                                        for: $0.bucket
                                                    ),
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
                            .class("admin-dashboard__traffic")
                        }
                    }
                    .class("admin-dashboard__primary-grid")
                }
                .class("admin-dashboard__section")
            }
            if !model.webInsightCards.isEmpty
                || !(model.topPages ?? []).isEmpty
            {
                Div {
                    Div {
                        if let icon = FeatherIcons.get(named: "users") {
                            Div { icon }
                                .class("admin-dashboard__section-icon")
                        }
                        Div {
                            H2("Audience insights")
                            P(
                                "Popular pages and a quick look at how visitors reach and use your site."
                            )
                        }
                        .class("admin-dashboard__section-heading-copy")
                    }
                    .class("admin-dashboard__section-heading")
                    Div {
                        if let topPages = model.topPages,
                            !topPages.isEmpty
                        {
                            context.build(
                                NewAdminChartCard(
                                    title: "Top pages",
                                    chart: NewAdminBarChart(
                                        items: topPages.map {
                                            .init(
                                                label: $0.label,
                                                value: $0.count,
                                                share: $0.share
                                            )
                                        },
                                        limit: 6
                                    )
                                )
                            )
                        }
                        for card in model.webInsightCards {
                            context.build(
                                NewAdminChartCard(
                                    title: card.title,
                                    chart: NewAdminBarChart(
                                        items: card.items.map {
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
                    }
                    .class("admin-dashboard__insights-grid")
                }
                .class("admin-dashboard__section")
            }
        }
        .class("admin-dashboard")
    }

    private func dateLabel(for timestamp: Double) -> String {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "MMM d"
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }

}
