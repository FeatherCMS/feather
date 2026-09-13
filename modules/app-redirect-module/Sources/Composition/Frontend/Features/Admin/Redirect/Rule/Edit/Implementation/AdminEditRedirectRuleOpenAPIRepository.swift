import FeatherAdmin
import FeatherContracts
import Foundation
import Hummingbird
import OpenAPIRuntime
import RedirectAdminAPI
import RedirectContracts

struct AdminEditRedirectRuleOpenAPIRepository:
    AdminEditRedirectRuleRepository
{
    let api: RedirectAdminAPIClient

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
                    statusCode: StatusCode(rawValue: rule.statusCode)!,
                    notes: rule.notes
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
                        statusCode: input.parsedStatusCode?.rawValue ?? 301,
                        notes: input.normalizedNotes.isEmpty
                            ? nil
                            : input.normalizedNotes
                    )
                )
            )
            switch response {
            case .ok:
                return
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
