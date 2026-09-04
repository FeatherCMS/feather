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
import WebComponents
import WebBuilders

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
        search: String?,
        userID: String?
    ) async throws -> (
        items: [AuthAdminAPI.Components.Schemas.AuthMagicLinkListItemSchema],
        emailByAuthEmailId: [String: String],
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
                            filters: .init(search: search, userId: userID)
                        )
                    )
                )
            switch response {
            case .ok(let ok):
                let body = try ok.body.json
                let emails = try await listEmails()
                return (
                    items: body.data.items,
                    emailByAuthEmailId: Dictionary(
                        uniqueKeysWithValues: emails.map {
                            (String($0.id), $0.email)
                        }
                    ),
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

    private func listEmails() async throws
        -> [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema]
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.authEmailList(
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let ok): return try ok.body.json
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view auth emails."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot access auth emails."
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
            _ = try await client.authMagicLinkDelete(
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }
}
