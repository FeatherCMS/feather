import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterSubscriberForm: Decodable, Sendable {
    let email: String
    let firstName: String
    let lastName: String
    let campaignIds: [String]?

    var selectedCampaignIds: Set<String> {
        Set((campaignIds ?? []).filter { !$0.isEmpty })
    }
}
