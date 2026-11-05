public import Foundation

public struct FeatherDateFormatter: @unchecked Sendable {
    private let dateTimeFormatter: Foundation.DateFormatter
    private let dateFormatter: Foundation.DateFormatter
    private let timeFormatter: Foundation.DateFormatter
    private let dateTimeInputFormatter: Foundation.DateFormatter
    private let dateOnlyInputFormatter: Foundation.DateFormatter
    private let iso8601DateTimeFormatter: ISO8601DateFormatter
    private let iso8601DateTimeWithFractionalSecondsFormatter:
        ISO8601DateFormatter

    public init(
        locale: String,
        timezone: String
    ) {
        let timeZone = TimeZone(identifier: timezone) ?? .gmt

        let dateTimeFormatter = Foundation.DateFormatter()
        dateTimeFormatter.locale = Locale(identifier: locale)
        dateTimeFormatter.timeZone = timeZone
        dateTimeFormatter.dateStyle = .medium
        dateTimeFormatter.timeStyle = .short
        self.dateTimeFormatter = dateTimeFormatter

        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.timeZone = timeZone
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d")
        self.dateFormatter = dateFormatter

        let timeFormatter = Foundation.DateFormatter()
        timeFormatter.locale = Locale(identifier: locale)
        timeFormatter.timeZone = timeZone
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        self.timeFormatter = timeFormatter

        let dateTimeInputFormatter = Foundation.DateFormatter()
        dateTimeInputFormatter.calendar = Calendar(identifier: .gregorian)
        dateTimeInputFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateTimeInputFormatter.timeZone = timeZone
        dateTimeInputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateTimeInputFormatter.isLenient = false
        self.dateTimeInputFormatter = dateTimeInputFormatter

        let dateOnlyInputFormatter = Foundation.DateFormatter()
        dateOnlyInputFormatter.calendar = Calendar(identifier: .gregorian)
        dateOnlyInputFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateOnlyInputFormatter.timeZone = timeZone
        dateOnlyInputFormatter.dateFormat = "yyyy-MM-dd"
        dateOnlyInputFormatter.isLenient = false
        self.dateOnlyInputFormatter = dateOnlyInputFormatter

        let iso8601DateTimeFormatter = ISO8601DateFormatter()
        iso8601DateTimeFormatter.formatOptions = [.withInternetDateTime]
        self.iso8601DateTimeFormatter = iso8601DateTimeFormatter

        let iso8601DateTimeWithFractionalSecondsFormatter =
            ISO8601DateFormatter()
        iso8601DateTimeWithFractionalSecondsFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
        ]
        self.iso8601DateTimeWithFractionalSecondsFormatter =
            iso8601DateTimeWithFractionalSecondsFormatter
    }

    public init(language: String, timezone: String) {
        self.init(locale: language, timezone: timezone)
    }

    public func formatDateTime(_ date: Date) -> String {
        dateTimeFormatter.string(from: date)
    }

    public func formatDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }

    public func formatTime(_ date: Date) -> String {
        timeFormatter.string(from: date)
    }

    public func formatDateTimeInput(_ date: Date) -> String {
        dateTimeInputFormatter.string(from: date)
    }

    public func formatDateTime(unixTimestamp: Double) -> String {
        formatDateTime(Date(timeIntervalSince1970: unixTimestamp))
    }

    public func formatDate(unixTimestamp: Double) -> String {
        formatDate(Date(timeIntervalSince1970: unixTimestamp))
    }

    public func formatTime(unixTimestamp: Double) -> String {
        formatTime(Date(timeIntervalSince1970: unixTimestamp))
    }

    public func formatDateTimeInput(unixTimestamp: Double) -> String {
        formatDateTimeInput(Date(timeIntervalSince1970: unixTimestamp))
    }

    public func parseDateTimeInput(_ value: String) -> Date? {
        dateTimeInputFormatter.date(from: value)
    }

    public func parseDateInput(_ value: String) -> Date? {
        dateOnlyInputFormatter.date(from: value)
    }

    public func parseDate(_ value: String) -> Date? {
        guard !value.isEmpty else { return nil }
        if let date = iso8601DateTimeWithFractionalSecondsFormatter.date(
            from: value
        ) {
            return date
        }
        if let date = iso8601DateTimeFormatter.date(from: value) {
            return date
        }
        if let date = parseDateTimeInput(value) {
            return date
        }
        return parseDateInput(value)
    }

    public func unixTimestamp(fromInput value: String) -> Double? {
        parseDate(value)?.timeIntervalSince1970
    }
}
