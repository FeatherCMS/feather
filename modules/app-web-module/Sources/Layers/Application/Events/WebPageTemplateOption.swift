public struct WebPageTemplateOption: Sendable, Hashable, Codable {
    public let value: String
    public let title: String

    public init(
        value: String,
        title: String
    ) {
        self.value = value
        self.title = title
    }
}
