import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditNewsletterCampaignSubscriberPresenter: Sendable {
    func render(
        newsletterId: String,
        item: AdminNewsletterCampaignSubscriberItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
