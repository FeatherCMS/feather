import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterSubscribersPresenter: Sendable {
    func renderRemovePage(
        items: [NewAdminRemoveItemContext],
        search: String?,
        campaignId: String?
    ) async throws -> HTMLResponse
}
