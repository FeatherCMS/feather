public struct AnalyticsLogAcceptLanguage: Sendable {
    public let language: String?
    public let region: String?

    public init(
        language: String?,
        region: String?
    ) {
        self.language = language
        self.region = region
    }
}
