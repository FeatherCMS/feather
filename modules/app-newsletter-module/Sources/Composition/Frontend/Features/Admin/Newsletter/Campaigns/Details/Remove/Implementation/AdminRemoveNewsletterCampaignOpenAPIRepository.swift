import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterCampaignOpenAPIRepository {
    let api: NewsletterAdminAPIClient
    func names(ids: [String]) async throws -> [String] {
        let campaigns = try await AdminNewsletterCampaignAPIClient(api: api)
            .list()
        let namesByID = Dictionary(
            uniqueKeysWithValues: campaigns.map { ($0.id, $0.name) }
        )
        return ids.map { namesByID[$0] ?? $0 }
    }
    func remove(id: String) async throws {
        try await AdminNewsletterCampaignAPIClient(api: api).remove(id: id)
    }
    func remove(ids: [String]) async throws {
        try await AdminNewsletterCampaignAPIClient(api: api)
            .remove(ids: ids)
    }
}
