import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletterCampaignModel: Sendable {
    let name: String
    let fromEmail: String
    let error: String?
}
