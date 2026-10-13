public import CSS
public import HTML
import SGML
import SVG
import WebBuilders
public import WebComponents

public struct NewAdminLineChart: Component {
    public struct Point: Sendable {
        public let label: String
        public let value: Int

        public init(label: String, value: Int) {
            self.label = label
            self.value = value
        }
    }

    public let points: [Point]
    public let color: String
    public let leftInset: Double
    public let rightInset: Double
    public let topInset: Double
    public let bottomInset: Double

    public init(
        points: [Point],
        color: String = "var(--accent-color-primary-hover)",
        leftInset: Double = 44,
        rightInset: Double = 24,
        topInset: Double = 24,
        bottomInset: Double = 26
    ) {
        self.points = points
        self.color = color
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.topInset = topInset
        self.bottomInset = bottomInset
    }

    public func rules() -> [any Rule] {
        Media {
            Custom(".new-admin-line-chart") {
                Display(.grid)
                Gap(8.px)
            }
            Custom(".new-admin-line-chart__labels") {
                Position(.relative)
                Height(1.2.rem)
            }
            Custom(".new-admin-line-chart__label") {
                Position(.absolute)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.72.rem)
                WhiteSpace(.nowrap)
            }
        }
    }

    public func html(context: inout BuilderContext) -> Div {
        let width = 720
        let height = 220
        let maxValue = Double(max(1, points.map(\.value).max() ?? 1))
        let yAxisGuideStart = max(
            leftInset,
            12 + Double(String(Int(maxValue)).count) * 7
        )
        let count = max(1, points.count - 1)
        let chartHeight = Double(height) - topInset - bottomInset
        let chartWidth = Double(width) - yAxisGuideStart - rightInset
        let chartPoints = points.enumerated()
            .map { index, point in
                let x =
                    yAxisGuideStart
                    + (Double(index) / Double(count)) * chartWidth
                let y =
                    Double(height) - bottomInset
                    - (Double(point.value) / maxValue) * chartHeight
                return (x: x, y: y)
            }
        let polylinePoints = chartPoints.flatMap { [$0.x, $0.y] }
        let areaPoints =
            ([(x: yAxisGuideStart, y: Double(height) - bottomInset)]
            + chartPoints + [
                (x: Double(width) - rightInset, y: Double(height) - bottomInset)
            ])
            .flatMap { [$0.x, $0.y] }

        let svg = SVG {
            Rect(x: 0, y: 0, width: Double(width), height: Double(height))
                .fill("var(--material-color-primary-tint)")
                .setAttribute(name: "rx", value: "10")
                .setAttribute(name: "ry", value: "10")
            for step in 0...4 {
                let ratio = Double(step) / 4.0
                let y = topInset + ratio * chartHeight
                Line(
                    x1: yAxisGuideStart,
                    y1: y,
                    x2: Double(width) - rightInset,
                    y2: y
                )
                .stroke("var(--material-color-primary-border)")
                .strokeWidth(1)
            }
            Line(
                x1: yAxisGuideStart,
                y1: Double(height) - bottomInset,
                x2: Double(width) - rightInset,
                y2: Double(height) - bottomInset
            )
            .stroke("var(--material-color-primary-border)")
            .strokeWidth(1)
            if polylinePoints.count >= 4 {
                Polygon(areaPoints).fill(color)
                    .setAttribute(name: "fill-opacity", value: "0.18")
                Polyline(polylinePoints)
                    .fill("none")
                    .stroke(color)
                    .strokeWidth(3)
                    .strokeLinejoin("round")
                    .strokeLinecap("round")
            }
            for step in 0...4 {
                let ratio = Double(step) / 4.0
                let value = Int((1.0 - ratio) * maxValue)
                let y = topInset + ratio * chartHeight + 4
                Text("\(value)")
                    .x(4)
                    .y(y)
                    .fill("var(--material-color-tertiary-text)")
                    .setAttribute(name: "font-size", value: "0.72rem")
                    .setAttribute(name: "text-anchor", value: "start")
            }
        }
        .setAttribute(
            name: "style",
            value:
                "display:block;width:100%;height:auto;border-radius:10px;overflow:visible;"
        )
        .width(width)
        .height(height)
        .viewBox(minX: 0, minY: 0, width: width, height: height)

        return Div {
            svg
            Div {
                for index in xAxisLabelIndices(points.count)
                where index < points.count {
                    let labelX =
                        yAxisGuideStart
                        + (Double(index) / Double(count)) * chartWidth
                    let labelPosition = labelX / Double(width) * 100
                    let labelAlignment =
                        index == 0 && points.count > 1
                        ? ""
                        : index == points.count - 1 && points.count > 1
                            ? "transform:translateX(-100%);"
                            : "transform:translateX(-50%);"
                    Span(points[index].label)
                        .class("new-admin-line-chart__label")
                        .setAttribute(
                            name: "style",
                            value:
                                "left:\(labelPosition)%;\(labelAlignment)"
                        )
                }
            }
            .class("new-admin-line-chart__labels")
            .setAttribute(name: "style", value: "position:relative;")
        }
        .class("new-admin-line-chart")
    }

    private func xAxisLabelIndices(_ count: Int) -> [Int] {
        guard count > 0 else { return [] }
        if count <= 2 { return Array(0..<count) }
        let desiredLabels = min(6, count)
        let step = max(1, (count - 1) / max(1, desiredLabels - 1))
        var indices = stride(from: 0, to: count, by: step).map { $0 }
        if indices.last != count - 1 { indices.append(count - 1) }
        return indices
    }
}
