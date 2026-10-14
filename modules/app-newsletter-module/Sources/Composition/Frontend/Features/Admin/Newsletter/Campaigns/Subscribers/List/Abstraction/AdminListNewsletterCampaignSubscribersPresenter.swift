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
        model: AdminListModel<AdminNewsletterCampaignSubscriberItem>,
        search: String?,
        error: String?,
        permissions: AdminListActions
    ) async throws -> HTMLResponse
}
