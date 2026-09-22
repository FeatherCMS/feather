import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditNewsletterCampaignPresenter: Sendable {
    func render(
        item: AdminNewsletterCampaignItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderEditError(
        id: String,
        item: AdminNewsletterCampaignItem,
        error: AdminEditNewsletterCampaignError,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminEditNewsletterCampaignError
    ) async throws -> HTMLResponse
}
