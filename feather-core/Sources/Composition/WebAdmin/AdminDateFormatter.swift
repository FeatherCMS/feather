public import Foundation

public struct AdminDateFormatter: @unchecked Sendable {
    private let dateTimeFormatter: DateFormatter
    private let dateFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    private let dateTimeInputFormatter: DateFormatter
    private let dateOnlyInputFormatter: DateFormatter
    private let iso8601DateTimeFormatter: ISO8601DateFormatter
    private let iso8601DateTimeWithFractionalSecondsFormatter:
        ISO8601DateFormatter

    public init(
        language: String,
        timezone: String
    ) {
        let timeZone = TimeZone(identifier: timezone) ?? .gmt

        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.locale = Locale(identifier: language)
        dateTimeFormatter.timeZone = timeZone
        dateTimeFormatter.dateStyle = .medium
        dateTimeFormatter.timeStyle = .short
        self.dateTimeFormatter = dateTimeFormatter

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: language)
        dateFormatter.timeZone = timeZone
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d")
        self.dateFormatter = dateFormatter

        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: language)
        timeFormatter.timeZone = timeZone
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        self.timeFormatter = timeFormatter

        let dateTimeInputFormatter = DateFormatter()
        dateTimeInputFormatter.calendar = Calendar(identifier: .gregorian)
        dateTimeInputFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateTimeInputFormatter.timeZone = timeZone
        dateTimeInputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateTimeInputFormatter.isLenient = false
        self.dateTimeInputFormatter = dateTimeInputFormatter

        let dateOnlyInputFormatter = DateFormatter()
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
}

extension AdminDateFormatter {
    public func formatDateTime(
        _ date: Date
    ) -> String {
        dateTimeFormatter.string(from: date)
    }

    public func formatDate(
        _ date: Date
    ) -> String {
        dateFormatter.string(from: date)
    }

    public func formatTime(
        _ date: Date
    ) -> String {
        timeFormatter.string(from: date)
    }

    public func formatDateTimeInput(
        _ date: Date
    ) -> String {
        dateTimeInputFormatter.string(from: date)
    }
}

extension AdminDateFormatter {
    public func formatDateTime(
        unixTimestamp: Double
    ) -> String {
        formatDateTime(Date(timeIntervalSince1970: unixTimestamp))
    }

    public func formatDate(
        unixTimestamp: Double
    ) -> String {
        formatDate(Date(timeIntervalSince1970: unixTimestamp))
    }

    public func formatTime(
        unixTimestamp: Double
    ) -> String {
        formatTime(Date(timeIntervalSince1970: unixTimestamp))
    }

    public func formatDateTimeInput(
        unixTimestamp: Double
    ) -> String {
        formatDateTimeInput(Date(timeIntervalSince1970: unixTimestamp))
    }
}

extension AdminDateFormatter {
    public func parseDateTimeInput(
        _ value: String
    ) -> Date? {
        dateTimeInputFormatter.date(from: value)
    }

    public func parseDateInput(
        _ value: String
    ) -> Date? {
        dateOnlyInputFormatter.date(from: value)
    }

    public func parseDate(
        _ value: String
    ) -> Date? {
        guard !value.isEmpty else {
            return nil
        }
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

    public func unixTimestamp(
        fromInput value: String
    ) -> Double? {
        parseDate(value)?.timeIntervalSince1970
    }
}
