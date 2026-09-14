import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignOpenAPIRepository {
    let api: NewsletterAdminAPIClient
    func get(id: String) async throws -> AdminNewsletterCampaignItem {
        try await AdminNewsletterCampaignAPIClient(api: api).get(id: id)
    }
}
