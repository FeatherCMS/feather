import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI

struct AdminEditSystemVariableOpenAPIRepository:
    AdminEditSystemVariableRepository
{
    let api: SystemAdminAPIClient

    func load(
        id: String
    ) async throws -> SystemVariableEditModel {
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
                    key: variable.key,
                    value: variable.value,
                    name: variable.name,
                    notes: variable.notes
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound
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

    func update(
        id: String,
        input: Components.Schemas.SystemVariableCreateSchema
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemVariableUpdate(
                path: .init(systemVariableId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(input)
            )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound
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
