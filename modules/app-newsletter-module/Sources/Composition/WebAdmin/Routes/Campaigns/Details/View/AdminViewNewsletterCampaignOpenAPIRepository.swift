import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterAdminAPI
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignOpenAPIRepository {
    let api: API.Client
    func get(id: String) async throws -> Campaign.Item {
        try await Campaign.APIClient(api: api).get(id: id)
    }
}
