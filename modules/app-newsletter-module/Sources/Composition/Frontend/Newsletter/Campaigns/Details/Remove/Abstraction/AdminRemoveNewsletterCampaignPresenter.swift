import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveNewsletterCampaignPresenter: Sendable {
    func render(id: String, permissions: Set<String>) -> HTMLResponse
}
