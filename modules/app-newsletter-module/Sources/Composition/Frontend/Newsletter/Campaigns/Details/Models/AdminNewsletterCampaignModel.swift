import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminNewsletterCampaignItem: Sendable {
    let id: String
    let name: String
    let fromEmail: String
}

struct NewsletterEditForm: Decodable {
    let name: String
    let fromEmail: String
}
