import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddNewsletterCampaignSubscriberPresenter: Sendable {
    func render(
        newsletterId: String,
        form: NewsletterCampaignSubscriberForm,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
