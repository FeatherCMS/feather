import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterCampaignModel: Sendable {
    let name: String
    let fromEmail: String
    let error: String?
}
