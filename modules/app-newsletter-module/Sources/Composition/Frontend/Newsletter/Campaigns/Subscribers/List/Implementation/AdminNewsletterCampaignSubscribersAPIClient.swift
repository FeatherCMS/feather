import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminNewsletterCampaignSubscribersAPIClient {
    let api: NewsletterAdminAPIClient

    func list(newsletterId: String) async throws
        -> [AdminNewsletterCampaignSubscriberItem]
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterSubscriberList(
                path: .init(newsletterCampaignId: newsletterId)
            )
            switch response {
            case .ok(let value):
                return try value.body.json.map {
                    .init(
                        id: $0.id,
                        email: $0.email,
                        firstName: $0.firstName ?? "",
                        lastName: $0.lastName ?? "",
                        status: $0.status
                    )
                }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view subscribers."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view subscribers."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func create(newsletterId: String, form: NewsletterCampaignSubscriberForm)
        async throws
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterSubscriberCreate(
                path: .init(newsletterCampaignId: newsletterId),
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
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to create subscribers."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create subscribers."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    {
        let email = try await email(
            newsletterId: newsletterId,
            subscriberId: subscriberId
        )
        return try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterSubscriberGet(
                path: .init(newsletterCampaignId: newsletterId, email: email)
            )
            switch response {
            case .ok(let value):
                let item = try value.body.json
                return AdminNewsletterCampaignSubscriberItem(
                    id: item.id,
                    email: item.email,
                    firstName: item.firstName ?? "",
                    lastName: item.lastName ?? "",
                    status: item.status
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This subscriber could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view this subscriber."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view this subscriber."
                )
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
        form: NewsletterCampaignSubscriberForm
    ) async throws {
        let email = try await email(
            newsletterId: newsletterId,
            subscriberId: subscriberId
        )
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterSubscriberUpdate(
                path: .init(newsletterCampaignId: newsletterId, email: email),
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
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This subscriber could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to edit subscribers."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit subscribers."
                )
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
            let response = try await client.newsletterSubscriberDelete(
                path: .init(newsletterCampaignId: newsletterId, email: email)
            )
            switch response {
            case .noContent: return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This subscriber could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to delete subscribers."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete subscribers."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private func email(newsletterId: String, subscriberId: String) async throws
        -> String
    {
        guard
            let item = try await list(newsletterId: newsletterId)
                .first(where: { $0.id == subscriberId })
        else {
            throw OpenAPIRepositoryError.notFound(
                message: "This subscriber could not be found."
            )
        }
        return item.email
    }
}
