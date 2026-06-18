import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminAddWebMenuOpenAPIRepository: AdminAddWebMenuRepository {
    let api: AdminAPI

    func create(
        input: WebMenuFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMenuCreate(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        key: input.normalizedKey,
                        name: input.normalizedName,
                        notes: input.normalizedNotes
                    )
                )
            )

            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to create this web menu."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create web menus."
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
