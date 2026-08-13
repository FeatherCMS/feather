import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditNewsletterCampaignOpenAPIRepository {
    let api: NewsletterAdminAPIClient
    func get(id: String) async throws -> AdminNewsletterCampaignItem {
        try await AdminNewsletterCampaignAPIClient(api: api).get(id: id)
    }
    func update(id: String, name: String, fromEmail: String) async throws {
        _ = try await AdminNewsletterCampaignAPIClient(api: api)
            .update(id: id, name: name, fromEmail: fromEmail)
    }
}
