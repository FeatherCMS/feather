import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletterCampaignSubscriberOpenAPIRepository {
    let api: NewsletterAdminAPIClient
    func create(newsletterId: String, form: NewsletterCampaignSubscriberForm)
        async throws
    {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .create(newsletterId: newsletterId, form: form)
    }
}
