import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterCampaignSubscriberOpenAPIRepository {
    let api: API.Client
    func create(newsletterId: String, form: NewsletterCampaignSubscriberForm)
        async throws
    {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .create(newsletterId: newsletterId, form: form)
    }
}
