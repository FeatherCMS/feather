import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignSubscriberOpenAPIRepository {
    let api: API.Client
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .get(newsletterId: newsletterId, subscriberId: subscriberId)
    }
}
