import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct NewsletterIssueAddForm: Decodable {
    var subject: String = ""
    var content: String = ""
    var scheduledAt: String = ""
    var normalizedSubject: String {
        subject.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
