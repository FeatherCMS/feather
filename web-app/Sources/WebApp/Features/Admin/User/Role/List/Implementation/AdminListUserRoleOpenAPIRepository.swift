import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminListUserRoleOpenAPIRepository: AdminListUserRoleRepository {
    let api: AdminAPI
    private let unauthorizedMessage =
        "Please sign in again to view user roles."

    init(api: AdminAPI) {
        self.api = api
    }

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserRoleListItemSchema], total: Int,
        page: Int, size: Int
    ) {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userRoleSearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: size, number: page),
                            filters: .init(search: search)
                        )
                    )
                )
            switch response {
            case .ok(let ok):
                let body = try ok.body.json
                return (
                    items: body.data.items,
                    total: body.data.total,
                    page: body.query.page.number,
                    size: body.query.page.size
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: unauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access user roles."
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
            _ =
                try await client
                .userRoleDelete(path: .init(userRoleId: id))
        }
    }
}
