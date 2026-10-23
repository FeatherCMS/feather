import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterCampaignSubscribersOpenAPIRepository {
    let api: API.Client
    func list(newsletterId: String) async throws
        -> [AdminNewsletterCampaignSubscriberItem]
    {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .list(newsletterId: newsletterId)
    }
}
