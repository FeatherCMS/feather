import FeatherAdmin
import FeatherValidation
import FeatherContracts
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
        subject.whitespaceTrimmed
    }
}
