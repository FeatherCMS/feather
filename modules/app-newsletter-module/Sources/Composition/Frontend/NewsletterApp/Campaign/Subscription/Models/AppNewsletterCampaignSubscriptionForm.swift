import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AppNewsletterCampaignSubscriptionForm: Codable, Sendable {
    let email: String
    let nonce: String?
    let redirect: String?
    let turnstileResponse: String?

    enum CodingKeys: String, CodingKey {
        case email
        case nonce
        case redirect
        case turnstileResponse = "cf-turnstile-response"
    }
}
