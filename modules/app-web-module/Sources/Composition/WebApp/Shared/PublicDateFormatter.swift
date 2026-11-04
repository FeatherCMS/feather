public import Foundation

public struct PublicDateFormatter {
    private let dateTimeFormatter: DateFormatter

    public init(
        locale: String,
        timezone: String
    ) {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.locale = Locale(identifier: locale)
        dateTimeFormatter.timeZone = TimeZone(identifier: timezone) ?? .gmt
        dateTimeFormatter.dateStyle = .medium
        dateTimeFormatter.timeStyle = .short
        self.dateTimeFormatter = dateTimeFormatter
    }
}

extension PublicDateFormatter {
    public func formatDateTime(
        _ date: Date
    ) -> String {
        dateTimeFormatter.string(from: date)
    }
}

extension PublicDateFormatter {
    public func formatDateTime(
        unixTimestamp: Double
    ) -> String {
        formatDateTime(Date(timeIntervalSince1970: unixTimestamp))
    }
}
