import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveNewsletterCampaignSubscriberInteractor: Sendable {
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    func remove(newsletterId: String, subscriberId: String) async throws
    func remove(newsletterId: String, subscriberIds: [String]) async throws
}
