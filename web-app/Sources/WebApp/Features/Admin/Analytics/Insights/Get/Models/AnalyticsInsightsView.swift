import AdminOpenAPI
import Foundation
import HTML
import SGML
import SVG
import WebStandards

struct AnalyticsInsightsView: Component {

    private let chartPrimaryColor = "var(--cms-primary-hover)"

    let page: AdminAnalyticsInsightsPage
    let permissions: Set<String>

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb)
            H1(page.source.pageTitle)
            P(page.source.summary)
                .setAttribute(
                    name: "style",
                    value: "margin:0 0 16px 0;"
                )
            filters
            metricGrid
            dailyChart
            breakdownSection
        }
        .class("cms-section")
    }

    private var breadcrumb: AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Analytics", link: "/admin/analytics/"),
                .init(label: page.source.pageTitle, link: page.source.pagePath),
            ]
        )
    }

    private var filters: some FlowContent {
        Form {
            Div {
                Select {
                    for range in [
                        AdminAnalyticsInsightsPage.Range.last24Hours,
                        .last7Days,
                        .last30Days,
                    ] {
                        if range == page.selectedRange {
                            Option(range.label).value(range.rawValue).selected()
                        }
                        else {
                            Option(range.label).value(range.rawValue)
                        }
                    }
                }
                .name("range")
                Button("Update")
                A("View logs")
                    .href(page.source.logsPath)
                    .class("button")
            }
            .class("table-search-form")
        }
        .method(.get)
        .action(page.source.pagePath)
    }

    private var metricGrid: some FlowContent {
        Div {
            if page.source == .web {
                metricCard("Requests", "\(page.overview.kpis.totalRequests)")
                metricCard(
                    "Avg/day",
                    averageValue(page.overview.kpis.averageRequestsPerDay)
                )
                metricCard(
                    "Signed-in",
                    "\(page.overview.kpis.authenticatedRequests)"
                )
                metricCard("404s", "\(page.overview.kpis.notFoundRequests)")
                metricCard("4xx", "\(page.overview.kpis.clientErrorRequests)")
                metricCard("5xx", "\(page.overview.kpis.serverErrorRequests)")
            }
            else {
                metricCard("Requests", "\(page.overview.kpis.totalRequests)")
                metricCard(
                    "Avg/day",
                    averageValue(page.overview.kpis.averageRequestsPerDay)
                )
                metricCard(
                    "Success rate",
                    percentageValue(successRate)
                )
                metricCard(
                    "Error rate",
                    percentageValue(errorRate)
                )
                metricCard(
                    "4xx errors",
                    "\(page.overview.kpis.clientErrorRequests)"
                )
                metricCard(
                    "5xx errors",
                    "\(page.overview.kpis.serverErrorRequests)"
                )
            }
        }
        .setAttribute(
            name: "style",
            value:
                "display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:12px;margin:16px 0;"
        )
    }

    private func metricCard(
        _ label: String,
        _ value: String
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

    private var dailyChart: some FlowContent {
        Div {
            H3("Daily traffic")
                .setAttribute(
                    name: "style",
                    value: "margin:0 0 16px 0;"
                )
            chartSVG
        }
        .setAttribute(
            name: "style",
            value:
                "margin:20px 0;padding:16px;border:1px solid var(--cms-gray-3);border-radius:12px;background:var(--cms-white);color:var(--cms-strong-font);"
        )
    }

    private var chartSVG: SVG {
        let points = page.overview.daily
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

    private var breakdownSection: some FlowContent {
        Div {
            if page.source == .web {
                Div {
                    breakdownCard("Top pages", page.overview.paths)
                    breakdownCard("Referrers", page.overview.referrers)
                }
                .class("grid", "grid-211")
                .setAttribute(
                    name: "style",
                    value: "column-gap:16px;row-gap:16px;"
                )
                Div {
                    breakdownCard(
                        "Operating systems",
                        page.overview.operatingSystems
                    )
                    breakdownCard("Browsers", page.overview.browsers)
                    breakdownCard("Device types", page.overview.deviceTypes)
                    breakdownCard("Languages", page.overview.languages)
                    breakdownCard("Regions", page.overview.regions)
                    breakdownCard("404 pages", page.overview.notFoundPaths)
                }
                .class("grid", "grid-321")
                .setAttribute(
                    name: "style",
                    value: "column-gap:16px;row-gap:16px;"
                )
            }
            else {
                breakdownCard("Top paths", page.overview.paths)
                breakdownCard("Methods", page.overview.methods)
                breakdownCard("Status codes", page.overview.statusFamilies)
                breakdownCard("5xx paths", page.overview.serverErrorPaths)
            }
        }
        .setAttribute(
            name: "style",
            value: "display:grid;gap:16px;"
        )
    }

    private func breakdownCard(
        _ title: String,
        _ items: [Components.Schemas.AnalyticsLogOverviewBreakdownItemSchema]
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
                for item in items.prefix(8) {
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

    private func averageValue(
        _ value: Double
    ) -> String {
        String(format: "%.1f", value)
    }

    private var successRate: Double {
        let total = Double(page.overview.kpis.totalRequests)
        guard total > 0 else {
            return 0
        }
        let errors =
            Double(page.overview.kpis.clientErrorRequests)
            + Double(page.overview.kpis.serverErrorRequests)
        return ((total - errors) / total) * 100
    }

    private var errorRate: Double {
        let total = Double(page.overview.kpis.totalRequests)
        guard total > 0 else {
            return 0
        }
        let errors =
            Double(page.overview.kpis.clientErrorRequests)
            + Double(page.overview.kpis.serverErrorRequests)
        return (errors / total) * 100
    }

    private func percentageValue(
        _ value: Double
    ) -> String {
        String(format: "%.1f%%", value)
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
        formatter.dateFormat =
            page.selectedRange == .last24Hours
            ? "HH:mm"
            : "MMM d"
        return formatter.string(from: date)
    }
}
