import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminGetUserAccountOpenAPIRepository: AdminGetUserAccountRepository {
    let api: AdminAPI
    private let getUnauthorizedMessage =
        "Please sign in again to load this user account."
    private let getSessionsUnauthorizedMessage =
        "Please sign in again to load this user's auth sessions."

    init(api: AdminAPI) {
        self.api = api
    }

    func get(
        id: String
    ) async throws -> UserAccountDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userAccountGet(
                path: .init(userAccountId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let account = try okResponse.body.json
                return .init(
                    id: account.id,
                    email: account.email,
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

    func getSessions(
        id: String
    ) async throws -> [Components.Schemas.UserAuthSessionListItemSchema] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userAccountSessionList(
                path: .init(userAccountId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                return try okResponse.body.json.items
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User account not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: getSessionsUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access auth sessions."
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
