import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditUserAccountOpenAPIRepository:
    AdminEditUserAccountRepository
{
    let api: AdminAPI
    private let getUnauthorizedMessage =
        "Please sign in again to load this user account."
    private let updateUnauthorizedMessage =
        "Please sign in again to update this user account."

    func get(
        id: String
    ) async throws -> AdminEditUserAccountModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userAccountGet(
                path: .init(userAccountId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let ok):
                let account = try ok.body.json
                return .init(
                    id: account.id,
                    email: account.email,
                    password: nil,
                    roleIds: Array(account.roleIds ?? [])
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User account not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: getUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access user accounts."
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
        payload: UserAccountFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userAccountPatch(
                path: .init(userAccountId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        email: payload.email,
                        password: payload.password,
                        roleIds: payload.roleIds
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User account not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: updateUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit user accounts."
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
