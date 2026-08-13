import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminGetUserIdentityOpenAPIRepository: AdminGetUserIdentityRepository {
    let api: UserAdminAPIClient
    private let getUnauthorizedMessage =
        "Please sign in again to load this user identity."

    init(
        api: UserAdminAPIClient
    ) {
        self.api = api
    }

    func get(
        id: String
    ) async throws -> UserIdentityDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userIdentityGet(
                path: .init(userIdentityId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let identity = try okResponse.body.json
                return .init(
                    id: identity.id,
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

}
