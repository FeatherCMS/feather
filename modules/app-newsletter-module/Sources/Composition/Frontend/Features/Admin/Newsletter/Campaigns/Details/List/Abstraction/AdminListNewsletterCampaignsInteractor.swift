import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterCampaignsInteractor: Sendable {
    func list() async throws -> [AdminNewsletterCampaignItem]
}
