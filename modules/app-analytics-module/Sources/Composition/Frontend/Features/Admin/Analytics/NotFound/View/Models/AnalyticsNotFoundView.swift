import AnalyticsAdminAPI
import FeatherAdmin
import Foundation
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct AnalyticsNotFoundView: Component {
    let model: AdminViewAnalyticsNotFoundModel

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
            let form = NewAdminForm(
                action: AnalyticsAdminRoutes.notFound.description,
                method: .get
            ) {
                context.build(
                    NewAdminFormFieldSelect(
                        state: .init(
                            name: "range",
                            label: "Date range",
                            value: model.selectedRange.rawValue,
                            options: [
                                .init(label: "Last 24 hours", value: "24h"),
                                .init(label: "Last 7 days", value: "7d"),
                                .init(label: "Last 30 days", value: "30d"),
                            ]
                        )
                    )
                )
                Div { context.build(NewAdminSubmitButton("Update")) }
                    .class("new-admin-form__actions")
            }
            context.build(form)
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
        .class("cms-section")
    }

    private func dateLabel(for timestamp: Double) -> String {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat =
            model.selectedRange == .last24Hours ? "HH:mm" : "MMM d"
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
