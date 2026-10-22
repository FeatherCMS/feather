public struct WebMarkdownRenderingContext: Sendable {
    public let formSubmissionNonce: String?
    public let formSubmissionFeedback: WebFormSubmissionFeedback?

    public init(
        formSubmissionNonce: String? = nil,
        formSubmissionFeedback: WebFormSubmissionFeedback? = nil
    ) {
        self.formSubmissionNonce = formSubmissionNonce
        self.formSubmissionFeedback = formSubmissionFeedback
    }
}
