public struct WebPublicContentResult: Sendable {
    public let payload: [String: any Sendable]
    public let usesFormSubmissionNonce: Bool

    public init(
        payload: [String: any Sendable],
        usesFormSubmissionNonce: Bool = false
    ) {
        self.payload = payload
        self.usesFormSubmissionNonce = usesFormSubmissionNonce
    }
}
