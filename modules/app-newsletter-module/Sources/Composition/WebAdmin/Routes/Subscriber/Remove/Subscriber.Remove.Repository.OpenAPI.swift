import FeatherWebAdmin
import FeatherWebShared
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime

extension Subscriber.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func remove(ids: [String], campaignId: String?) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let newslettersResponse =
                    try await client.newsletterCampaignList()
                guard case .ok(let newslettersValue) = newslettersResponse
                else {
                    throw OpenAPIRepositoryError.forbidden
                }
                for newsletter in try newslettersValue.body.json {
                    if campaignId?.isEmpty == false,
                        campaignId != newsletter.key
                    {
                        continue
                    }
                    let response = try await client.newsletterSubscriberList(
                        path: .init(newsletterCampaignKey: newsletter.key)
                    )
                    guard case .ok(let value) = response else { continue }
                    for subscriber in try value.body.json
                    where ids.contains(subscriber.id) {
                        _ = try await client.newsletterSubscriberRemove(
                            path: .init(
                                newsletterCampaignKey: newsletter.key
                            ),
                            body: .json(.init(ids: [subscriber.email]))
                        )
                    }
                }
            }
        }
    }
}
