import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI

struct AdminAddSystemVariableOpenAPIRepository: AdminAddSystemVariableRepository
{
    let api: SystemAdminAPIClient

    func create(
        input: Components.Schemas.SystemVariableCreateSchema
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemVariableCreate(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(input)
            )

            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
