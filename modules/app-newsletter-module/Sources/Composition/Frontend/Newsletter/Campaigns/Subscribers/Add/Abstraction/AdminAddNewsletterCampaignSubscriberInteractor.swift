import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddNewsletterCampaignSubscriberInteractor: Sendable {
    func create(newsletterId: String, form: NewsletterCampaignSubscriberForm)
        async throws
}
