import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AppNewsletterCampaignSubscriptionForm: Decodable, Sendable {
    let email: String
    let nonce: String?
    let redirect: String?
}
