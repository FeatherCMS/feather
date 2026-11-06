public struct ContentRenderingOutput: Sendable {
    public let html: String
    public let usesFormSubmissionNonce: Bool

    public init(
        html: String,
        usesFormSubmissionNonce: Bool
    ) {
        self.html = html
        self.usesFormSubmissionNonce = usesFormSubmissionNonce
    }
}
