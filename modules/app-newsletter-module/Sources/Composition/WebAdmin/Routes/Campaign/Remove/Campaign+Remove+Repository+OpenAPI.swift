import FeatherWebAdmin
import FeatherWebShared
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime

extension Campaign.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func remove(id: String) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.newsletterCampaignRemove(
                    body: .json(.init(ids: [id]))
                )
            }
        }

        func remove(ids: [String]) async throws {
            for id in ids {
                try await api.withOpenAPIRepositoryErrorMapping { client in
                    _ = try await client.newsletterCampaignRemove(
                        body: .json(.init(ids: [id]))
                    )
                }
            }
        }
    }
}
