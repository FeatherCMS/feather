import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterCampaignSubscriberPresenter: Sendable {
    func render(
        newsletterId: String,
        item: NewAdminRemoveItemContext
    ) async throws -> HTMLResponse
}
