import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminListNewsletterCampaignsPresenter: Sendable {
    func render(
        items: [AdminNewsletterCampaignItem],
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        isPicker: Bool,
        error: String?,
        permissions: Set<String>,
        search: String
    ) -> HTMLResponse
}
