import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletterCampaignSubscriberDefaultInteractor:
    AdminAddNewsletterCampaignSubscriberInteractor
{
    let repository: AdminAddNewsletterCampaignSubscriberOpenAPIRepository
    func create(newsletterId: String, form: NewsletterCampaignSubscriberForm)
        async throws
    { try await repository.create(newsletterId: newsletterId, form: form) }
}
