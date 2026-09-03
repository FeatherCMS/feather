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

    func listRoles() async throws -> [Components.Schemas.UserRoleListItemSchema]
    {
        let result = try await AdminListUserRoleOpenAPIRepository(api: api)
            .list(
                page: 1,
                size: 100,
                search: nil
            )
        return result.items
    }

    func list(
        page: Int,
        size: Int,
        search: String?,
        role: String?
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
                            filters: .init(search: search, role: role)
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
            _ = try await client.userIdentityDelete(
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }
}
