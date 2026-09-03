import FeatherAdmin
import FeatherContracts
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminEditUserIdentityOpenAPIRepository:
    AdminEditUserIdentityRepository
{
    let api: UserAdminAPIClient
    private let getUnauthorizedMessage =
        "Please sign in again to load this user identity."
    private let updateUnauthorizedMessage =
        "Please sign in again to update this user identity."

    func get(
        id: String
    ) async throws -> AdminEditUserIdentityModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userIdentityGet(
                path: .init(userIdentityId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let ok):
                let identity = try ok.body.json
                return .init(
                    id: identity.id,
                    name: identity.name,
                    status: identity.status.rawValue,
                    roleIds: Array(identity.roleIds ?? [])
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User identity not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: getUnauthorizedMessage
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

    func update(
        id: String,
        payload: UserIdentityFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userIdentityPatch(
                path: .init(userIdentityId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        name: payload.name,
                        status: .init(rawValue: payload.status) ?? .invited,
                        roleIds: payload.roleIds
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User identity not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: updateUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot edit user identities."
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
