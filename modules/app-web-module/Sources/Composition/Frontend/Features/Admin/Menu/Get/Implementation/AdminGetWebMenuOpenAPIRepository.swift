import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI

struct AdminGetWebMenuOpenAPIRepository: AdminGetWebMenuRepository {
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
}
