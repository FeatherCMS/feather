import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminRemoveNewsletterCampaignSubscriberPresenter: Sendable {
    func render(
        newsletterId: String,
        subscriberId: String,
        email: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
