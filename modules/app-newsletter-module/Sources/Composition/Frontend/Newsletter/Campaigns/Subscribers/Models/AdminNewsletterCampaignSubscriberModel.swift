import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminNewsletterCampaignSubscriberItem: Sendable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let status: String
}

struct NewsletterCampaignSubscriberForm: Decodable {
    let email: String
    let firstName: String
    let lastName: String
    let status: String
}
