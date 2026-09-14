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
        model: NewAdminListModel<AdminNewsletterCampaignSubscriberItem>,
        search: String?,
        error: String?,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse
}
