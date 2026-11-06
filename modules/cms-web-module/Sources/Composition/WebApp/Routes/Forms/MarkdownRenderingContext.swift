public struct MarkdownRenderingContext: Sendable {
    public let formSubmissionNonce: String?
    public let formSubmissionFeedback: FormSubmissionFeedback?

    public init(
        formSubmissionNonce: String? = nil,
        formSubmissionFeedback: FormSubmissionFeedback? = nil
    ) {
        self.formSubmissionNonce = formSubmissionNonce
        self.formSubmissionFeedback = formSubmissionFeedback
    }
}
