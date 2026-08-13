import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListNewsletterCampaignSubscribersOpenAPIRepository {
    let api: NewsletterAdminAPIClient
    func list(newsletterId: String) async throws
        -> [AdminNewsletterCampaignSubscriberItem]
    {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .list(newsletterId: newsletterId)
    }
}
