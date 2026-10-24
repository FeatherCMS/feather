import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import NewsletterAdminAPI
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Campaign.Subscriber {
    struct APIClient {
        let api: API.Client

        func list(newsletterId: String) async throws -> [Item] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterSubscriberList(
                    path: .init(newsletterCampaignKey: newsletterId)
                )
                switch response {
                case .ok(let value):
                    return try value.body.json.map {
                        Item(
                            id: $0.id,
                            email: $0.email,
                            firstName: $0.firstName ?? "",
                            lastName: $0.lastName ?? "",
                            status: $0.status
                        )
                    }
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

        func create(newsletterId: String, form: Form) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterSubscriberCreate(
                    path: .init(newsletterCampaignKey: newsletterId),
                    body: .json(
                        .init(
                            email: form.email,
                            firstName: form.firstName,
                            lastName: form.lastName,
                            status: form.status
                        )
                    )
                )
                switch response {
                case .created: return
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

        func get(newsletterId: String, subscriberId: String) async throws
            -> Item
        {
            let email = try await email(
                newsletterId: newsletterId,
                subscriberId: subscriberId
            )
            return try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterSubscriberGet(
                    path: .init(
                        newsletterCampaignKey: newsletterId,
                        email: email
                    )
                )
                switch response {
                case .ok(let value):
                    let item = try value.body.json
                    return Item(
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
            form: Form
        ) async throws {
            let email = try await email(
                newsletterId: newsletterId,
                subscriberId: subscriberId
            )
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterSubscriberUpdate(
                    path: .init(
                        newsletterCampaignKey: newsletterId,
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
                    let data = try JSONEncoder().encode(
                        try response.body.json
                    )
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

        func remove(newsletterId: String, subscriberId: String) async throws {
            let email = try await email(
                newsletterId: newsletterId,
                subscriberId: subscriberId
            )
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.newsletterSubscriberRemove(
                    path: .init(newsletterCampaignKey: newsletterId),
                    body: .json(.init(ids: [email]))
                )
            }
        }

        private func email(
            newsletterId: String,
            subscriberId: String
        ) async throws -> String {
            guard
                let item = try await list(newsletterId: newsletterId)
                    .first(where: { $0.id == subscriberId })
            else {
                throw OpenAPIRepositoryError.notFound
            }
            return item.email
        }
    }
}
