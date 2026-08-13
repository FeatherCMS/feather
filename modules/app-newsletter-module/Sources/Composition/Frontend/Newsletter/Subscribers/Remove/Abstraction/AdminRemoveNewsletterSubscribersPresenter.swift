import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveNewsletterSubscribersPresenter: Sendable {
    func render(
        ids: [String],
        search: String?,
        campaignId: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
