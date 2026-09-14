import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddNewsletterCampaignSubscriberInteractor: Sendable {
    func create(newsletterId: String, form: NewsletterCampaignSubscriberForm)
        async throws
}
