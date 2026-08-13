public protocol WebContentRenderer: Sendable {
    func render(
        markdown: String,
        requestPath: String
    ) async -> String
}
