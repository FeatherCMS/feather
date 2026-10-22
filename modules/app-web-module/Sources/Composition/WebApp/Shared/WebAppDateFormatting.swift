import Foundation

enum WebAppDateFormatting {
    private static let timestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    static func formatUnixTimestamp(_ value: Double) -> String {
        timestampFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
