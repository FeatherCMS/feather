import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminGetNewsletterCampaignSubscriberPresenter: Sendable {
    func render(
        newsletterId: String,
        item: AdminNewsletterCampaignSubscriberItem,
        permissions: Set<String>
    ) -> HTMLResponse
}
