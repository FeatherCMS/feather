import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterCampaignSubscribersPresenter: Sendable {
    func render(
        newsletterId: String,
        items: [AdminNewsletterCampaignSubscriberItem],
        search: String?,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
