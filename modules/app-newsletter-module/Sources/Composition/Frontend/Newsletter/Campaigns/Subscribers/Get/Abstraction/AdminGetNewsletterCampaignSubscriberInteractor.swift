import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminGetNewsletterCampaignSubscriberInteractor: Sendable {
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
}
