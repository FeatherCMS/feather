import FeatherWebAdmin
import FeatherWebShared
import Foundation
import NewsletterAdminAPI
import NewsletterModule
import OpenAPIRuntime

extension Campaign.Subscriber.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(newsletterId: String, subscriberId: String) async throws
            -> Campaign.Subscriber.Item
        {
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
            return try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterSubscriberGet(
                    path: .init(
                        newsletterCampaignId: newsletterId,
                        email: email
                    )
                )
                switch response {
                case .ok(let value):
                    let item = try value.body.json
                    return Campaign.Subscriber.Item(
                        id: item.id,
                        email: item.email,
                        firstName: item.firstName ?? "",
                        lastName: item.lastName ?? "",
                        status: item.status
                    )
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
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
        }

        func update(
            newsletterId: String,
            subscriberId: String,
            form: Campaign.Subscriber.Form.Input
        ) async throws {
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
                let response = try await client.newsletterSubscriberUpdate(
                    path: .init(
                        newsletterCampaignId: newsletterId,
                        email: email
                    ),
                    query: .init(updateMask: "firstName,lastName,status"),
                    body: .json(
                        .init(
                            firstName: form.firstName,
                            lastName: form.lastName,
                            status: form.status
                        )
                    )
                )
                switch response {
                case .ok: return
                case .badRequest(let response):
                    let data = try JSONEncoder()
                        .encode(try response.body.json)
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(data: data, encoding: .utf8)
                    )
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
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
        }
    }
}
