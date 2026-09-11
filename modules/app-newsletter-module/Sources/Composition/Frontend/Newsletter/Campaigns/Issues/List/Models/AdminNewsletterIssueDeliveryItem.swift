import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminNewsletterIssueDeliveryItem: Sendable {
    let issueSubject: String
    let subscriberEmail: String
    let status: String
    let sentAt: String
    let failureReason: String
}
