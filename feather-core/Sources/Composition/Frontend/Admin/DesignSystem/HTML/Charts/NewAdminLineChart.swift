import CSS
import HTML
import SGML
import SVG
import WebBuilders
import WebComponents

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

    public init(
        points: [Point],
        color: String = "var(--accent-color-primary-hover)"
    ) {
        self.points = points
        self.color = color
    }

    public func html(context: inout BuilderContext) -> SVG {
        let width = 720
        let height = 220
        let leftInset = 44.0
        let rightInset = 24.0
        let topInset = 24.0
        let bottomInset = 26.0
        let maxValue = Double(max(1, points.map(\.value).max() ?? 1))
        let count = max(1, points.count - 1)
        let chartHeight = Double(height) - topInset - bottomInset
        let chartWidth = Double(width) - leftInset - rightInset
        let chartPoints = points.enumerated()
            .map { index, point in
                let x = leftInset + (Double(index) / Double(count)) * chartWidth
                let y =
                    Double(height) - bottomInset
                    - (Double(point.value) / maxValue) * chartHeight
                return (x: x, y: y)
            }
        let polylinePoints = chartPoints.flatMap { [$0.x, $0.y] }
        let areaPoints =
            ([(x: leftInset, y: Double(height) - bottomInset)] + chartPoints + [
                (x: Double(width) - rightInset, y: Double(height) - bottomInset)
            ])
            .flatMap { [$0.x, $0.y] }

        return SVG {
            Rect(x: 0, y: 0, width: Double(width), height: Double(height))
                .fill("var(--material-color-primary-tint)")
                .setAttribute(name: "rx", value: "10")
                .setAttribute(name: "ry", value: "10")
            for step in 0...4 {
                let ratio = Double(step) / 4.0
                let y = topInset + ratio * chartHeight
                let value = Int((1.0 - ratio) * maxValue)
                Line(
                    x1: leftInset,
                    y1: y,
                    x2: Double(width) - rightInset,
                    y2: y
                )
                .stroke("var(--material-color-primary-border)")
                .strokeWidth(1)
                Text("\(value)")
                    .x(leftInset - 8)
                    .y(y + 4)
                    .fill("var(--material-color-tertiary-text)")
                    .setAttribute(name: "font-size", value: "11")
                    .setAttribute(name: "text-anchor", value: "end")
            }
            Line(
                x1: leftInset,
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
                for point in chartPoints {
                    Circle(cx: point.x, cy: point.y, r: 3.5).fill(color)
                }
            }
            for index in xAxisLabelIndices(points.count)
            where index < chartPoints.count {
                Text(points[index].label)
                    .x(chartPoints[index].x)
                    .y(Double(height) - 8)
                    .fill("var(--material-color-tertiary-text)")
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
