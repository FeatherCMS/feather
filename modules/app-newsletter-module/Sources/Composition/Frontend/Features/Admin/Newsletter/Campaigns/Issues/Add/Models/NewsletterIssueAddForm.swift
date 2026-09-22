import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct NewsletterIssueAddForm: Decodable {
    var subject: String = ""
    var content: String = ""
    var scheduledAt: String = ""
    var normalizedSubject: String {
        subject.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var scheduledAtTimestamp: Double? {
        let value = scheduledAt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter.date(from: value)?.timeIntervalSince1970
    }
}
