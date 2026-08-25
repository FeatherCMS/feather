import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminRemoveUserRoleOpenAPIRepository: AdminRemoveUserRoleRepository {
    let api: UserAdminAPIClient

    init(api: UserAdminAPIClient) {
        self.api = api
    }

    init() {
        self.api = UserAdminAPIClient(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: nil
        )
    }

    func get(
        id: String
    ) async throws -> UserRoleDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userRoleGet(
                    path: .init(userRoleId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            switch response {
            case .ok(let ok):
                let item = try ok.body.json
                return .init(
                    id: item.id,
                    name: item.name ?? "",
                    notes: item.notes ?? ""
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User role not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load this user role."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot access user roles."
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
            _ = try await client.userRoleBulkDelete(
                body: .json(.init(ids: [id], summary: true))
            )
        }
    }
}
