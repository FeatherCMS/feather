import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListNewsletterCampaignsInteractor: Sendable {
    func list() async throws -> [AdminNewsletterCampaignItem]
}
