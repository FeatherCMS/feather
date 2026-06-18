import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminRemoveSystemPermissionOpenAPIRepository:
    AdminRemoveSystemPermissionRepository
{
    let api: AdminAPI

    func get(
        id: String
    ) async throws -> SystemPermissionDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemPermissionGet(
                path: .init(systemPermissionId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )

            switch response {
            case .ok(let okResponse):
                let permission = try okResponse.body.json
                return .init(
                    id: permission.id,
                    name: permission.name,
                    notes: permission.notes
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "System permission not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to load this system permission."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot delete system permissions."
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
            let response = try await client.systemPermissionDelete(
                path: .init(systemPermissionId: id)
            )

            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "System permission not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to delete this system permission."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot delete system permissions."
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
