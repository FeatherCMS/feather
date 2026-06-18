import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminAddRedirectRuleOpenAPIRepository: AdminAddRedirectRuleRepository {
    let api: AdminAPI

    func create(
        input: RedirectRuleFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.redirectRuleCreate(
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
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to create this redirect rule."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot create redirect rules."
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
