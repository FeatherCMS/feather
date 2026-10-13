import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI

struct AdminEditWebMenuOpenAPIRepository: AdminEditWebMenuRepository {
    let api: WebAdminAPIClient

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
                    notes: menu.notes
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
