struct CellMarkdownBlockRenderer: MarkdownBlockRenderer {
    let name = "Cell"

    func render(
        request: MarkdownBlockRendererRequest
    ) async -> String? {
        request.children.map { $0.html }.joined()
    }
}
