import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditUserRoleOpenAPIRepository: AdminEditUserRoleRepository {
    let api: AdminAPI

    init(api: AdminAPI) {
        self.api = api
    }

    init() {
        self.api = AdminAPI(
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
                return .init(id: item.id, name: item.name, notes: item.notes)
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
                    message: "Your account cannot edit user roles."
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
        payload: UserRoleFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userRoleUpdate(
                    path: .init(userRoleId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(.init(name: payload.name, notes: payload.notes))
                )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User role not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to update this user role."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit user roles."
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
