import FeatherWebAdmin
import FeatherWebShared
import NewsletterAdminAPI
import NewsletterModule
import OpenAPIRuntime

extension Campaign.Subscriber.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func remove(newsletterId: String, subscriberIds: [String]) async throws
        {
            for subscriberId in subscriberIds {
                let email = try await api.withOpenAPIRepositoryErrorMapping {
                    client in
                    let response = try await client.newsletterSubscriberList(
                        path: .init(newsletterCampaignId: newsletterId)
                    )
                    switch response {
                    case .ok(let value):
                        guard
                            let item = try value.body.json.first(where: {
                                $0.id == subscriberId
                            })
                        else {
                            throw OpenAPIRepositoryError.notFound
                        }
                        return item.email
                    case .unauthorized:
                        throw OpenAPIRepositoryError.unauthorized
                    case .forbidden:
                        throw OpenAPIRepositoryError.forbidden
                    case .undocumented(let statusCode, let response):
                        throw try await api.failure(
                            statusCode: statusCode,
                            responseBody: response.body
                        )
                    }
                }
                try await api.withOpenAPIRepositoryErrorMapping { client in
                    _ = try await client.newsletterSubscriberRemove(
                        path: .init(newsletterCampaignId: newsletterId),
                        body: .json(.init(ids: [email]))
                    )
                }
            }
        }
    }
}
