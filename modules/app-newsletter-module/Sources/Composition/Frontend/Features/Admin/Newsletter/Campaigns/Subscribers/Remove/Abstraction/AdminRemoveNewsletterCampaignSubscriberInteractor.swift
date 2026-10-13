import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterCampaignSubscriberInteractor: Sendable {
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    func names(newsletterId: String, subscriberIds: [String]) async throws
        -> [String]
    func remove(newsletterId: String, subscriberId: String) async throws
    func remove(newsletterId: String, subscriberIds: [String]) async throws
}
