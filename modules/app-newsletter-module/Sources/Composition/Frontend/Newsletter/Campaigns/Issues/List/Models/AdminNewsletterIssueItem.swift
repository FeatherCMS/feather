import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminNewsletterIssueItem: Sendable {
    let id: String
    let subject: String
    let status: String
    let scheduledAt: String
    let createdAt: String
    let deliveries: [AdminNewsletterIssueDeliveryItem]
}
