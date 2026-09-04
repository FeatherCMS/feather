import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditNewsletterCampaignInteractor: Sendable {
    func get(id: String) async throws -> AdminNewsletterCampaignItem
    func update(id: String, name: String, fromEmail: String) async throws
}
