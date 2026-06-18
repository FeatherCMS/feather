import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminAddSystemVariableOpenAPIRepository: AdminAddSystemVariableRepository
{
    let api: AdminAPI

    func create(
        input: SystemVariableFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemVariableCreate(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        name: input.normalizedName,
                        value: input.normalizedValue,
                        notes: input.normalizedNotes
                    )
                )
            )

            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to create this system variable."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot create system variables."
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
