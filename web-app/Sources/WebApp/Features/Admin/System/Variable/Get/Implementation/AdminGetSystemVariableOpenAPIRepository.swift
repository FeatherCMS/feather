import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminGetSystemVariableOpenAPIRepository: AdminGetSystemVariableRepository
{
    let api: AdminAPI

    func get(
        id: String
    ) async throws -> SystemVariableDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .systemVariableGet(
                    path: .init(systemVariableId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            switch response {
            case .ok(let okResponse):
                let variable = try okResponse.body.json
                return .init(
                    id: variable.id,
                    name: variable.name,
                    value: variable.value,
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
                        "Your account cannot access system variables."
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
