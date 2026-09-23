public protocol WebContentRenderer: Sendable {

    func render(
        markdown: String
    ) async -> String
}
