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
                Gap(32.px)
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
    }

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: AnalyticsAdminRoutes.breadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "404s",
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
            context.build(
                NewAdminChartCard(
                    title: "Daily traffic",
                    chart: NewAdminLineChart(
                        points: model.overview.daily.map {
                            .init(
                                label: dateLabel(for: $0.bucket),
                                value: $0.notFoundRequests
                            )
                        }
                    )
                )
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
        .class("analytics-not-found")
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
