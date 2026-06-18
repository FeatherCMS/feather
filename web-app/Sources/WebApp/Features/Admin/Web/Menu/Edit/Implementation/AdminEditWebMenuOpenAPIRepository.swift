import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditWebMenuOpenAPIRepository: AdminEditWebMenuRepository {
    let api: AdminAPI

    func load(
        id: String
    ) async throws -> WebMenuDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMenuGet(
                path: .init(webMenuId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let menu = try okResponse.body.json
                return .init(
                    id: menu.id,
                    key: menu.key,
                    name: menu.name,
                    notes: menu.notes,
                    items: []
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Web menu not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load this web menu."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access web menus."
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
        input: WebMenuFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMenuUpdate(
                path: .init(webMenuId: id),
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
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Web menu not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to update this web menu."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit web menus."
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
