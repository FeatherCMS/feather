import Foundation
import HTML
import SGML
import SVG
import WebStandards

struct AdminGetHomeComponent: Component {
    private let chartPrimaryColor = "var(--cms-primary-hover)"

    let model: AdminGetHomeModel

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(
                state: .init(links: [.init(label: "Admin", link: "/admin/")])
            )
            H1("Dashboard")
            P(model.summary)
                .setAttribute(
                    name: "style",
                    value: "margin:0 0 16px 0;"
                )
            H2("Last week")
                .setAttribute(
                    name: "style",
                    value: "margin:0 0 16px 0;"
                )
            contentStats
            secondarySection
        }
        .class("cms-section")
    }

    private var contentStats: some FlowContent {
        Div {
            if model.contentStats.isEmpty {
                emptyCard("No accessible content stats.")
            }
            else {
                for item in model.contentStats {
                    metricCard(label: item.label, value: item.value)
                }
            }
        }
        .setAttribute(
            name: "style",
            value:
                "display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:12px;margin:16px 0;"
        )
    }

    private var secondarySection: some FlowContent {
        Div {
            if let dailyTraffic = model.dailyTraffic {
                dailyTrafficCard(dailyTraffic)
            }
            webInsightsGrid
            H2("Quick actions")
                .setAttribute(
                    name: "style",
                    value: "margin:0 0 16px 0;"
                )
            quickActionsGrid
        }
    }

    private func dailyTrafficCard(
        _ points: [AdminGetHomeModel.TrafficPoint]
    ) -> some FlowContent {
        Div {
            H3("Daily traffic")
                .setAttribute(
                    name: "style",
                    value: "margin:0 0 16px 0;"
                )
            trafficChartSVG(points)
        }
        .setAttribute(
            name: "style",
            value:
                "margin:0 0 16px 0;padding:16px;border:1px solid var(--cms-gray-3);border-radius:12px;background:var(--cms-white);color:var(--cms-strong-font);"
        )
    }

    private var webInsightsGrid: some FlowContent {
        guard !model.webInsightCards.isEmpty else {
            return Div {}
        }
        return Div {
            for card in model.webInsightCards {
                breakdownCard(card.title, card.items)
            }
        }
        .class("grid", "grid-321")
        .setAttribute(
            name: "style",
            value:
                "display:grid;column-gap:16px;row-gap:16px;margin:0 0 16px 0;"
        )
    }

    private func metricCard(
        label: String,
        value: String
    ) -> some FlowContent {
        Div {
            P(label)
                .setAttribute(
                    name: "style",
                    value: "margin:0 0 6px 0;font-size:0.9rem;opacity:0.7;"
                )
            Strong(value)
                .setAttribute(
                    name: "style",
                    value: "font-size:1.4rem;"
                )
        }
        .setAttribute(
            name: "style",
            value:
                "border:1px solid var(--cms-gray-3);border-radius:10px;padding:14px;background:var(--cms-white);color:var(--cms-strong-font);"
        )
    }

    private var quickActionsGrid: some FlowContent {
        Div {
            if model.quickLinkGroups.isEmpty {
                emptyCard("No quick actions available.")
            }
            else {
                for group in model.quickLinkGroups {
                    quickActionCard(group)
                }
            }
        }
        .class("grid", "grid-321")
        .setAttribute(
            name: "style",
            value: "display:grid;column-gap:16px;row-gap:16px;margin-top:16px;"
        )
    }

    private func quickActionCard(
        _ group: AdminGetHomeModel.QuickLinkGroup
    ) -> some FlowContent {
        Div {
            H3(group.label)
                .setAttribute(
                    name: "style",
                    value: "margin:0 0 12px 0;font-size:1.15rem;"
                )
            Div {
                for action in group.actions {
                    A(action.label)
                        .href(action.href)
                        .class(action.style.cssClass)
                }
            }
            .class("button-row")
        }
        .setAttribute(
            name: "style",
            value:
                "padding:16px;border:1px solid var(--cms-gray-3);border-radius:12px;background:var(--cms-white);color:var(--cms-strong-font);"
        )
    }

    private func breakdownCard(
        _ title: String,
        _ items: [AdminGetHomeModel.BreakdownItem]
    ) -> some FlowContent {
        Div {
            H3(title)
                .setAttribute(
                    name: "style",
                    value: "margin:0 0 16px 0;"
                )
            if items.isEmpty {
                P("No data in this window.")
            }
            else {
                for item in items {
                    Div {
                        Div {
                            Span(item.label)
                                .setAttribute(
                                    name: "style",
                                    value:
                                        "display:block;min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"
                                )
                            Span("\(item.count)")
                                .setAttribute(
                                    name: "style",
                                    value: "flex-shrink:0;"
                                )
                        }
                        .setAttribute(
                            name: "style",
                            value:
                                "display:flex;justify-content:space-between;align-items:baseline;gap:12px;font-size:0.95rem;min-width:0;"
                        )
                        Div {
                            Div {}
                                .setAttribute(
                                    name: "style",
                                    value:
                                        "display:block;width:\(max(3, Int(item.share * 100)))%;height:10px;border-radius:999px;background:\(chartPrimaryColor);"
                                )
                        }
                        .setAttribute(
                            name: "style",
                            value:
                                "margin-top:6px;background:var(--cms-gray-2);border-radius:999px;overflow:hidden;"
                        )
                    }
                    .setAttribute(
                        name: "style",
                        value: "margin:0 0 12px 0;"
                    )
                }
            }
        }
        .setAttribute(
            name: "style",
            value:
                "padding:16px;border:1px solid var(--cms-gray-3);border-radius:12px;background:var(--cms-white);color:var(--cms-strong-font);"
        )
    }

    private func trafficChartSVG(
        _ points: [AdminGetHomeModel.TrafficPoint]
    ) -> SVG {
        let width = 720
        let height = 220
        let leftInset = 44.0
        let rightInset = 24.0
        let topInset = 24.0
        let bottomInset = 26.0
        let maxValue = Double(max(1, points.map(\.requests).max() ?? 1))
        let count = max(1, points.count - 1)
        let chartHeight = Double(height) - topInset - bottomInset
        let chartPoints = points.enumerated()
            .map { index, point in
                let chartWidth = Double(width)
                let x =
                    leftInset + (Double(index) / Double(count))
                    * (chartWidth - leftInset - rightInset)
                let y =
                    Double(height) - bottomInset
                    - (Double(point.requests) / maxValue) * chartHeight
                return (x: x, y: y)
            }
        let polylinePoints = chartPoints.flatMap { [$0.x, $0.y] }
        let areaPoints =
            ([(x: leftInset, y: Double(height) - bottomInset)]
            + chartPoints
            + [(x: Double(width) - rightInset, y: Double(height) - bottomInset)])
            .flatMap { [$0.x, $0.y] }
        let labelPoints = xAxisLabelIndices(points.count)
            .compactMap { index -> (x: Double, label: String)? in
                guard index < chartPoints.count, index < points.count else {
                    return nil
                }
                return (
                    x: chartPoints[index].x,
                    label: xAxisLabel(for: points[index].bucket)
                )
            }
        let yAxisPoints = (0...4)
            .map { step -> (y: Double, label: String) in
                let ratio = Double(step) / 4.0
                let y = topInset + ratio * chartHeight
                let value = Int((1.0 - ratio) * maxValue)
                return (y: y, label: "\(value)")
            }

        return SVG {
            Rect(x: 0, y: 0, width: Double(width), height: Double(height))
                .fill("var(--cms-white)")
                .setAttribute(name: "rx", value: "10")
                .setAttribute(name: "ry", value: "10")
            for yAxisPoint in yAxisPoints {
                Line(
                    x1: leftInset,
                    y1: yAxisPoint.y,
                    x2: Double(width) - rightInset,
                    y2: yAxisPoint.y
                )
                .stroke("var(--cms-gray-3)")
                .strokeWidth(1)
                Text(yAxisPoint.label)
                    .x(leftInset - 8)
                    .y(yAxisPoint.y + 4)
                    .fill("var(--cms-light-font)")
                    .setAttribute(name: "font-size", value: "11")
                    .setAttribute(name: "text-anchor", value: "end")
            }
            Line(
                x1: leftInset,
                y1: Double(height) - bottomInset,
                x2: Double(width) - rightInset,
                y2: Double(height) - bottomInset
            )
            .stroke("var(--cms-gray-3)")
            .strokeWidth(1)
            if polylinePoints.count >= 4 {
                Polygon(areaPoints)
                    .fill(chartPrimaryColor)
                    .setAttribute(name: "fill-opacity", value: "0.18")
                Polyline(polylinePoints)
                    .fill("none")
                    .stroke(chartPrimaryColor)
                    .strokeWidth(3)
                    .strokeLinejoin("round")
                    .strokeLinecap("round")
                for point in chartPoints {
                    Circle(cx: point.x, cy: point.y, r: 3.5)
                        .fill(chartPrimaryColor)
                }
            }
            for labelPoint in labelPoints {
                Text(labelPoint.label)
                    .x(labelPoint.x)
                    .y(Double(height) - 8)
                    .fill("var(--cms-light-font)")
                    .setAttribute(name: "font-size", value: "11")
                    .setAttribute(name: "text-anchor", value: "middle")
            }
        }
        .setAttribute(
            name: "style",
            value:
                "display:block;width:100%;height:auto;border-radius:10px;overflow:hidden;"
        )
        .width(width)
        .height(height)
        .viewBox(minX: 0, minY: 0, width: width, height: height)
    }

    private func xAxisLabelIndices(
        _ count: Int
    ) -> [Int] {
        guard count > 0 else {
            return []
        }
        if count <= 2 {
            return Array(0..<count)
        }
        let desiredLabels = min(6, count)
        let step = max(1, (count - 1) / max(1, desiredLabels - 1))
        var indices = stride(from: 0, to: count, by: step).map { $0 }
        if indices.last != count - 1 {
            indices.append(count - 1)
        }
        return indices
    }

    private func xAxisLabel(
        for timestamp: Double
    ) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }

    private func emptyCard(
        _ message: String
    ) -> some FlowContent {
        Div {
            P(message)
        }
        .setAttribute(
            name: "style",
            value:
                "border:1px solid var(--cms-gray-3);border-radius:10px;padding:14px;background:var(--cms-white);color:var(--cms-strong-font);"
        )
    }
}
