import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminNewsletterSubscribersListModel: Sendable {
    let items: [AdminNewsletterSubscriberListItem]
    let campaigns: [AdminNewsletterSubscriberCampaign]
    let search: String
    let campaignId: String
}
