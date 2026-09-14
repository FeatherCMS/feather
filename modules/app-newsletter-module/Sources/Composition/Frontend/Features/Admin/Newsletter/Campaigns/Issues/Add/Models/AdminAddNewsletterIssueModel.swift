import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterIssueModel: Sendable {
    let subject: String
    let content: String
    let scheduledAt: String
    let newsletterId: String
    let error: String?
}
