import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminAddUserRoleOpenAPIRepository: AdminAddUserRoleRepository {

    let api: AdminAPI

    func create(
        payload: UserRoleFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userRoleCreate(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(.init(name: payload.name, notes: payload.notes))
                )
            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to create this user role."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create user roles."
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
