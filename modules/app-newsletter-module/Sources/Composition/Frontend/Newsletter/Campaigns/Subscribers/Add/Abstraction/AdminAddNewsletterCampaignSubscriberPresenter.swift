import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddNewsletterCampaignSubscriberPresenter: Sendable {
    func render(
        newsletterId: String,
        form: NewsletterCampaignSubscriberForm,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
