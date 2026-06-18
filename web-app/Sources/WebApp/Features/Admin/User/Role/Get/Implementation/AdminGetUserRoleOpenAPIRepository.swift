import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminGetUserRoleOpenAPIRepository: AdminGetUserRoleRepository {
    let api: AdminAPI

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
                let role = try ok.body.json
                return .init(id: role.id, name: role.name, notes: role.notes)
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
                    message: "Your account cannot access user roles."
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
