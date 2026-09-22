import FeatherAdmin
import Foundation
import HTML
import SGML
import WebBuilders
import WebComponents

struct AdminViewDashboardComponent: Component {
    let model: AdminViewDashboardModel

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: []))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Dashboard",
                        description: model.summary
                    )
                )
            )
            Div {
                for item in model.contentStats {
                    context.build(
                        NewAdminStatCard(label: item.label, value: item.value)
                    )
                }
            }
            .class("grid", "grid-321")
            if let dailyTraffic = model.dailyTraffic {
                context.build(
                    NewAdminChartCard(
                        title: "Daily traffic",
                        chart: NewAdminLineChart(
                            points: dailyTraffic.map {
                                .init(
                                    label: dateLabel(for: $0.bucket),
                                    value: $0.requests
                                )
                            }
                        )
                    )
                )
            }
            if !model.webInsightCards.isEmpty {
                Div {
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
                .class("grid", "grid-321")
            }
        }
        .class("cms-section")
    }

    private func dateLabel(for timestamp: Double) -> String {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "MMM d"
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
