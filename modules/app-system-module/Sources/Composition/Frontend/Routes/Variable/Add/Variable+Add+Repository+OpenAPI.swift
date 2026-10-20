import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Variable.Add.Repository {
    struct OpenAPI: WebAdmin.System.Variable.Add.Repository.Interface {
        let api: SystemAdminAPIClient

        func create(
            input: Components.Schemas.SystemVariableCreateSchema
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.systemVariablePost(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(input)
                )

                switch response {
                case .created:
                    return
                case .badRequest(let response):
                    let data = try JSONEncoder().encode(try response.body.json)
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(data: data, encoding: .utf8)
                    )
                case .conflict:
                    throw OpenAPIRepositoryError.conflict
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
