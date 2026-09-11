import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditNewsletterCampaignSubscriberPresenter: Sendable {
    func render(
        newsletterId: String,
        item: AdminNewsletterCampaignSubscriberItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
