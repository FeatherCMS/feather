import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddNewsletterCampaignSubscriberInteractor: Sendable {
    func create(newsletterId: String, form: NewsletterCampaignSubscriberForm)
        async throws
}
