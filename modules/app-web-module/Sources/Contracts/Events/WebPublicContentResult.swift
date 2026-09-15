public struct WebPublicContentResult: Sendable {
    public let payload: [String: any Sendable]

    public init(
        payload: [String: any Sendable]
    ) {
        self.payload = payload
    }
}
