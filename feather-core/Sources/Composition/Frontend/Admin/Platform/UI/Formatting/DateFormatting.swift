import Foundation

public enum DateFormatting {
    static let sharedTimestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    public static func formatUnixTimestamp(
        _ value: Double
    ) -> String {
        let date = Date(timeIntervalSince1970: value)
        return sharedTimestampFormatter.string(from: date)
    }
}
