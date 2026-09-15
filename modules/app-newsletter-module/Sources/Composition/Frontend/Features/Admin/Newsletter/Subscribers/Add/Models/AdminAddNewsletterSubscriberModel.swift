import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterSubscriberModel: Sendable {
    let email: String
    let firstName: String
    let lastName: String
    let selectedCampaignIds: Set<String>
    let campaigns: [AdminNewsletterSubscriberCampaign]
    let error: String?
}
