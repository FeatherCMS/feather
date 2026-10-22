public protocol ContentRenderer: Sendable {

    func render(
        markdown: String
    ) async -> String

    func render(
        markdown: String,
        context: MarkdownRenderingContext
    ) async -> (html: String, usesFormSubmissionNonce: Bool)
}
