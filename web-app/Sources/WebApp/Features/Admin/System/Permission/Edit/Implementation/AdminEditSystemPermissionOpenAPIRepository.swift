import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditSystemPermissionOpenAPIRepository:
    AdminEditSystemPermissionRepository
{
    let api: AdminAPI

    func load(
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
                        "Your account cannot edit system permissions."
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
        input: SystemPermissionFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemPermissionUpdate(
                path: .init(systemPermissionId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        name: input.normalizedName,
                        notes: input.normalizedNotes
                    )
                )
            )

            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "System permission not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to update this system permission."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot edit system permissions."
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
