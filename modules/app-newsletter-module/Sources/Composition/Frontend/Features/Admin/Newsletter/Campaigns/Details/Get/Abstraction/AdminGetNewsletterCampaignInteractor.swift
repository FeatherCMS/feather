import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminGetNewsletterCampaignInteractor: Sendable {
    func get(id: String) async throws -> AdminNewsletterCampaignItem
}
