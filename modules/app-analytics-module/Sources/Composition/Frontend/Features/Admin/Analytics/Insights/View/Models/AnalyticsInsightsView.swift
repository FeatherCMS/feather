import AnalyticsAdminAPI
import FeatherAdmin
import Foundation
import HTML
import SGML
import WebBuilders
import WebComponents

struct AnalyticsInsightsView: Component {
    let page: AdminAnalyticsInsightsPage

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: page.source.pageTitle,
                        description: page.source.summary
                    )
                )
            )
            let form = NewAdminForm(action: page.source.pagePath, method: .get)
            {
                context.render(
                    NewAdminFormFieldSelect(
                        state: .init(
                            name: "range",
                            label: "Date range",
                            value: page.selectedRange.rawValue,
                            options: [
                                .init(label: "Last 24 hours", value: "24h"),
                                .init(label: "Last 7 days", value: "7d"),
                                .init(label: "Last 30 days", value: "30d"),
                            ]
                        )
                    )
                )
                Div {
                    context.render(NewAdminSubmitButton("Update"))
                    context.render(
                        NewAdminButton(
                            "View logs",
                            href: page.source.logsPath,
                            style: .secondary
                        )
                    )
                }
                .class("new-admin-form__actions")
            }
            context.render(form)
            Div {
                for item in metrics {
                    context.render(
                        NewAdminStatCard(label: item.0, value: item.1)
                    )
                }
            }
            .class("grid", "grid-321")
            context.render(
                NewAdminChartCard(
                    title: "Daily traffic",
                    chart: NewAdminLineChart(
                        points: page.overview.daily.map {
                            .init(
                                label: dateLabel(for: $0.bucket),
                                value: $0.requests
                            )
                        }
                    )
                )
            )
            Div {
                for card in breakdowns {
                    context.render(card)
                }
            }
            .class("grid", "grid-321")
        }
        .class("cms-section")
    }

    private var breadcrumb: [NewAdminBreadcrumb.Link] {
        AnalyticsAdminRoutes.breadcrumb
    }

    private var metrics: [(String, String)] {
        let kpis = page.overview.kpis
        if page.source == .web {
            return [
                ("Requests", "\(kpis.totalRequests)"),
                ("Avg/day", String(format: "%.1f", kpis.averageRequestsPerDay)),
                ("Signed-in", "\(kpis.authenticatedRequests)"),
                ("404s", "\(kpis.notFoundRequests)"),
                ("4xx", "\(kpis.clientErrorRequests)"),
                ("5xx", "\(kpis.serverErrorRequests)"),
            ]
        }
        return [
            ("Requests", "\(kpis.totalRequests)"),
            ("Avg/day", String(format: "%.1f", kpis.averageRequestsPerDay)),
            ("Success rate", String(format: "%.1f%%", successRate)),
            ("Error rate", String(format: "%.1f%%", errorRate)),
            ("4xx errors", "\(kpis.clientErrorRequests)"),
            ("5xx errors", "\(kpis.serverErrorRequests)"),
        ]
    }

    private var breakdowns: [NewAdminChartCard<NewAdminBarChart>] {
        let overview = page.overview
        if page.source == .web {
            return [
                breakdown("Top pages", overview.paths),
                breakdown("Referrers", overview.referrers),
                breakdown("Operating systems", overview.operatingSystems),
                breakdown("Browsers", overview.browsers),
                breakdown("Device types", overview.deviceTypes),
                breakdown("Languages", overview.languages),
                breakdown("Regions", overview.regions),
                breakdown("404 pages", overview.notFoundPaths),
            ]
        }
        return [
            breakdown("Top paths", overview.paths),
            breakdown("Methods", overview.methods),
            breakdown("Status codes", overview.statusFamilies),
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
            page.selectedRange == .last24Hours ? "HH:mm" : "MMM d"
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
