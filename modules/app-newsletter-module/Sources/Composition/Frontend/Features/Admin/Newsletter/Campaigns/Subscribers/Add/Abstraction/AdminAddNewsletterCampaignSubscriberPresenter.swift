import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddNewsletterCampaignSubscriberPresenter: Sendable {
    func render(
        newsletterId: String,
        form: NewsletterCampaignSubscriberForm,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
