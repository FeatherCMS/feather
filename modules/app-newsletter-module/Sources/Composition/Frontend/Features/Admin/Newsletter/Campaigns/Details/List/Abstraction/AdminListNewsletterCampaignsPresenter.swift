import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterCampaignsPresenter: Sendable {
    func render(
        model: NewAdminListModel<AdminNewsletterCampaignItem>,
        isPicker: Bool,
        error: String?,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse
}
