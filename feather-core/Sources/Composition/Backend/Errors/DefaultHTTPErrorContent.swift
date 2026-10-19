public struct DefaultHTTPErrorContent: HTTPErrorContent {
    public let message: String
    public let reason: String

    public init(
        message: String,
        reason: String
    ) {
        self.message = message
        self.reason = reason
    }
}
