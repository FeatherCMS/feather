import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminRemoveRedirectRuleOpenAPIRepository:
    AdminRemoveRedirectRuleRepository
{
    let api: AdminAPI

    func get(
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
                        "Your account cannot delete redirect rules."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.redirectRuleDelete(
                path: .init(redirectRuleId: id)
            )
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Redirect rule not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to delete this redirect rule."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot delete redirect rules."
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
