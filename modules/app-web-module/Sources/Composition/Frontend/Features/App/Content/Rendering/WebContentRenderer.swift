public protocol WebContentRenderer: Sendable {

    func render(
        markdown: String
    ) async -> String

    func render(
        markdown: String,
        context: WebMarkdownRenderingContext
    ) async -> (html: String, usesFormSubmissionNonce: Bool)
}
