import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletterIssueModel: Sendable {
    let subject: String
    let content: String
    let scheduledAt: String
    let newsletterId: String
    let error: String?
}
