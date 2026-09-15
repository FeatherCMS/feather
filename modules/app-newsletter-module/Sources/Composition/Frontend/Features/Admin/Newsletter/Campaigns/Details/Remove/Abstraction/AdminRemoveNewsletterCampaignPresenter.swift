import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterCampaignPresenter: Sendable {
    func render(item: NewAdminRemoveItemContext) async throws
        -> HTMLResponse
}
