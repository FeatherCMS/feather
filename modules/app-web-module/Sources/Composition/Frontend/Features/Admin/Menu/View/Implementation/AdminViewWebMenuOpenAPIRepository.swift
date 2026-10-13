import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI

struct AdminViewWebMenuOpenAPIRepository: AdminViewWebMenuRepository {
    let api: WebAdminAPIClient

    func get(
        id: String
    ) async throws -> WebMenuDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            async let menuResponse =
                client
                .webMenuGet(
                    path: .init(webMenuId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            let response = try await menuResponse
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
}
