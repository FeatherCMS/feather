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

struct AdminListAuthEmailOpenAPIRepository:
    AdminListAuthEmailRepository
{
    let api: AuthAdminAPIClient
    let userAPI: UserAdminAPIClient
    private let listUnauthorizedMessage =
        "Please sign in again to view user emails."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this user email."

    func list(
        page: Int,
        size: Int,
        search: String?,
        userID: String?
    ) async throws -> (
        items: [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema],
        identityNames: [String: String],
        total: Int,
        page: Int, size: Int
    ) {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .authEmailList(
                    headers: .init(accept: [.init(contentType: .json)])
                )
            switch response {
            case .ok(let ok):
                let body = try ok.body.json
                var identityNames: [String: String] = [:]
                for identityID in Set(body.map(\.identityId)) {
                    let identityResponse = try await userAPI
                        .withOpenAPIRepositoryErrorMapping { client in
                            try await client.userIdentityGet(
                                path: .init(userIdentityId: identityID),
                                headers: .init(accept: [.init(contentType: .json)])
                            )
                        }
                    if case .ok(let identityOK) = identityResponse {
                        identityNames[identityID] = try identityOK.body.json.name
                    }
                }
                return (
                    items: body,
                    identityNames: identityNames,
                    total: body.count,
                    page: page,
                    size: size
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: listUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot access user emails."
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
            _ = try await client.authEmailDelete(
                path: .init(authEmailId: id),
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }
}
