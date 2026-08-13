import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveNewsletterCampaignSubscriberDefaultInteractor:
    AdminRemoveNewsletterCampaignSubscriberInteractor
{
    let repository: AdminRemoveNewsletterCampaignSubscriberOpenAPIRepository
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    {
        try await repository.get(
            newsletterId: newsletterId,
            subscriberId: subscriberId
        )
    }
    func remove(newsletterId: String, subscriberId: String) async throws {
        try await repository.remove(
            newsletterId: newsletterId,
            subscriberId: subscriberId
        )
    }
    func remove(newsletterId: String, subscriberIds: [String]) async throws {
        try await repository.remove(
            newsletterId: newsletterId,
            subscriberIds: subscriberIds
        )
    }
}
