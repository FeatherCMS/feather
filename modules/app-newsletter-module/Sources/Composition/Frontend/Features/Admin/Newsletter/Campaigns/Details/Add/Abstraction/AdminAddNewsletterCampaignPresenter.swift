import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddNewsletterCampaignPresenter: Sendable {
    func renderPage(
        model: AdminAddNewsletterCampaignModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
