public struct AccountSettingsModel: Sendable, Equatable, Hashable {

    public static let defaultLanguage = "en"
    public static let defaultTimezone = "UTC"
    public static let defaultPageSize = 20

    public let language: String
    public let timezone: String
    public let pageSize: Int

    public init(
        language: String = Self.defaultLanguage,
        timezone: String = Self.defaultTimezone,
        pageSize: Int = Self.defaultPageSize
    ) {
        self.language = language
        self.timezone = timezone
        self.pageSize = pageSize
    }
}
