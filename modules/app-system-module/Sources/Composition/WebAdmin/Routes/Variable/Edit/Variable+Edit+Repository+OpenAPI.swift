import FeatherWebAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI
import SystemModule

extension Variable.Edit.Repository {
    struct OpenAPI:
        Variable.Edit.Repository.Interface
    {
        let api: API.Client

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
                let response = try await client.systemVariablePut(
                    path: .init(systemVariableId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(input)
                )
                switch response {
                case .ok:
                    return
                case .badRequest(let response):
                    let data = try JSONEncoder().encode(try response.body.json)
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(data: data, encoding: .utf8)
                    )
                case .conflict:
                    throw OpenAPIRepositoryError.conflict
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
}
