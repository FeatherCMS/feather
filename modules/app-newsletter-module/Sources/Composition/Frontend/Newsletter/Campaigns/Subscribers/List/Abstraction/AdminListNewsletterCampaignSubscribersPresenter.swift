import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListNewsletterCampaignSubscribersPresenter: Sendable {
    func render(
        newsletterId: String,
        items: [AdminNewsletterCampaignSubscriberItem],
        search: String?,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
