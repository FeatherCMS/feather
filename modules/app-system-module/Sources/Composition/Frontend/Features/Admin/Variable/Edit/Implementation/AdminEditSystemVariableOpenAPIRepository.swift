import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI

struct AdminEditSystemVariableOpenAPIRepository:
    AdminEditSystemVariableRepository
{
    let api: SystemAdminAPIClient

    func load(
        id: String
    ) async throws -> SystemVariableDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemVariableGet(
                path: .init(systemVariableId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let variable = try okResponse.body.json
                return .init(
                    id: variable.id,
                    value: variable.value,
                    name: variable.name,
                    notes: variable.notes
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "System variable not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to load this system variable."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot edit system variables."
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
        input: SystemVariableFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemVariableUpdate(
                path: .init(systemVariableId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        id: id,
                        value: input.normalizedValue,
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
                    message: "System variable not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to update this system variable."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot edit system variables."
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
