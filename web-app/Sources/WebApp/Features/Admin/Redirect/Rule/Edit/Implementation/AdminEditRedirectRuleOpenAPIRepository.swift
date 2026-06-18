import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditRedirectRuleOpenAPIRepository:
    AdminEditRedirectRuleRepository
{
    let api: AdminAPI

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.redirectRuleGet(
                path: .init(redirectRuleId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let rule = try okResponse.body.json
                return .init(
                    id: rule.id,
                    source: rule.source,
                    destination: rule.destination,
                    statusCode: rule.statusCode,
                    notes: rule.notes
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Redirect rule not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load this redirect rule."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot edit redirect rules."
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
        id: String,
        input: RedirectRuleFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.redirectRuleUpdate(
                path: .init(redirectRuleId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        source: input.normalizedSource,
                        destination: input.normalizedDestination,
                        statusCode: input.parsedStatusCode ?? 301,
                        notes: input.normalizedNotes
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Redirect rule not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to update this redirect rule."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot edit redirect rules."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
