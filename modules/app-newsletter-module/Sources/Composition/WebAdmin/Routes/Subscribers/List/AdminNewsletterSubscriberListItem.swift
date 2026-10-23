import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminNewsletterSubscriberListItem: Sendable {
    let id: String
    let email: String
    let name: String
    let newsletters: [NewsletterSubscriberCampaignMembership]
}
