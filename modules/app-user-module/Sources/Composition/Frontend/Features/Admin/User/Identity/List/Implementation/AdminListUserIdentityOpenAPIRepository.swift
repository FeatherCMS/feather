import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminListUserIdentityOpenAPIRepository:
    AdminListUserIdentityRepository
{
    let api: UserAdminAPIClient
    private let listUnauthorizedMessage =
        "Please sign in again to view user identities."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this user identity."

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserIdentityListItemSchema], total: Int,
        page: Int, size: Int
    ) {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userIdentitySearch(
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
                    message: listUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot access user identities."
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
            let response =
                try await client
                .userIdentityDelete(path: .init(userIdentityId: id))
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User identity not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: deleteUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot delete user identities."
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
