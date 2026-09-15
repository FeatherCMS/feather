import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterCampaignsInteractor: Sendable {
    func list(
        page: Int,
        search: String?
    ) async throws -> NewAdminListModel<AdminNewsletterCampaignItem>
}
