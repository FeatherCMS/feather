import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditNewsletterCampaignDefaultInteractor:
    AdminEditNewsletterCampaignInteractor
{
    let repository: AdminEditNewsletterCampaignOpenAPIRepository
    func get(id: String) async throws -> AdminNewsletterCampaignItem {
        try await repository.get(id: id)
    }
    func update(id: String, name: String, fromEmail: String) async throws {
        try await repository.update(id: id, name: name, fromEmail: fromEmail)
    }
}
