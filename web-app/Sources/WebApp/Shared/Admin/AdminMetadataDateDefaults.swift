import Foundation

enum AdminMetadataDateDefaults {

    static func publicationDate(
        _ value: String?
    ) -> String {
        let trimmed =
            value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if trimmed.isEmpty {
            return currentLocalDateTime()
        }
        return trimmed
    }

    private static func currentLocalDateTime() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter.string(from: Date())
    }
}
