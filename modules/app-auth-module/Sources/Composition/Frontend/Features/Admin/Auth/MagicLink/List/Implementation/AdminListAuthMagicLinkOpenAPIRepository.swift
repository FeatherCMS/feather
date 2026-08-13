import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

struct AdminListAuthMagicLinkOpenAPIRepository:
    AdminListAuthMagicLinkRepository
{
    let api: AuthAdminAPIClient
    private let listUnauthorizedMessage =
        "Please sign in again to view user magic links."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this user magic link."

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [AuthAdminAPI.Components.Schemas.AuthMagicLinkListItemSchema],
        total: Int,
        page: Int, size: Int
    ) {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .authMagicLinkSearch(
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
                    message: "Your identity cannot access user magic links."
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
                .authMagicLinkDelete(path: .init(authMagicLinkId: id))
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User magic link not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: deleteUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot delete user magic links."
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
