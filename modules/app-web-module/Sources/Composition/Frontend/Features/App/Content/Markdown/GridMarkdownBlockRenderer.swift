import Foundation

struct GridMarkdownBlockRenderer: WebMarkdownBlockRenderer {
    let name = "Grid"

    func render(
        request: WebMarkdownBlockRendererRequest
    ) async -> String? {
        let cells = request.children.filter {
            $0.name.caseInsensitiveCompare("Cell") == .orderedSame
        }
        guard !cells.isEmpty else { return nil }

        let desktop = columnCount(request.arguments["desktop"], fallback: 3)
        let tablet = columnCount(request.arguments["tablet"], fallback: 2)
        let mobile = columnCount(request.arguments["mobile"], fallback: 1)
        let gridClass = "grid-\(desktop)\(tablet)\(mobile)"
        let contents = cells.map { "<div>\($0.html)</div>" }.joined()
        return "<div class=\"grid \(gridClass)\">\(contents)</div>"
    }

    private func columnCount(_ value: String?, fallback: Int) -> Int {
        guard let value, let count = Int(value) else { return fallback }
        return max(1, min(4, count))
    }
}

struct CellMarkdownBlockRenderer: WebMarkdownBlockRenderer {
    let name = "Cell"

    func render(
        request: WebMarkdownBlockRendererRequest
    ) async -> String? {
        request.children.map { $0.html }.joined()
    }
}
