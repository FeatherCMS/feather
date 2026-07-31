protocol MarkdownBlockRenderer: Sendable {
    var name: String { get }

    func render(
        identifier: String,
        requestPath: String
    ) async -> String?
}
