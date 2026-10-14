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
        items: [AdminRemoveItemContext],
        search: String?,
        campaignId: String?,
        returnTo: String?
    ) async throws -> HTMLResponse
}
