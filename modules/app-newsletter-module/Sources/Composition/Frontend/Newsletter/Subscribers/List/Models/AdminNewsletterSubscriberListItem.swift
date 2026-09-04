import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminNewsletterSubscriberListItem: Sendable {
    let id: String
    let email: String
    let name: String
    let newsletters: [NewsletterSubscriberCampaignMembership]
}

struct NewsletterSubscriberCampaignMembership: Sendable {
    let id: String
    let name: String
    let status: String
}
