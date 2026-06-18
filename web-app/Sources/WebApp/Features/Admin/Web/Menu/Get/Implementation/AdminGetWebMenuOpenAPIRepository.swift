import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminGetWebMenuOpenAPIRepository: AdminGetWebMenuRepository {
    let api: AdminAPI

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
            async let itemsResponse =
                client
                .webMenuItemSearch(
                    path: .init(webMenuId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 100, number: 1),
                            filters: .init(search: nil)
                        )
                    )
                )
            let response = try await menuResponse
            switch response {
            case .ok(let okResponse):
                let menu = try okResponse.body.json
                let items: [Components.Schemas.WebMenuItemListItemSchema]
                switch try await itemsResponse {
                case .ok(let itemsOk):
                    items = try itemsOk.body.json.data.items
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized(
                        message: "Please sign in again to load web menu items."
                    )
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden(
                        message:
                            "Your account cannot access web menu items."
                    )
                case .undocumented(let statusCode, let undocumentedResponse):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: undocumentedResponse.body
                    )
                }
                return .init(
                    id: menu.id,
                    key: menu.key,
                    name: menu.name,
                    notes: menu.notes,
                    items: items
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
