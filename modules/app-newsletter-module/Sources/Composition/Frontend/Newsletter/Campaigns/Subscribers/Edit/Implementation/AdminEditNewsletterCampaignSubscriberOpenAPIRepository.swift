import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditNewsletterCampaignSubscriberOpenAPIRepository {
    let api: NewsletterAdminAPIClient
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .get(newsletterId: newsletterId, subscriberId: subscriberId)
    }
    func update(
        newsletterId: String,
        subscriberId: String,
        form: NewsletterCampaignSubscriberForm
    ) async throws {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .update(
                newsletterId: newsletterId,
                subscriberId: subscriberId,
                form: form
            )
    }
}
