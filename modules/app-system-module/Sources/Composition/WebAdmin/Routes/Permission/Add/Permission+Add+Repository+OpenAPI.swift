import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI
import SystemModule

extension Permission.Add.Repository {
    struct OpenAPI:
        Permission.Add.Repository.Interface
    {
        let api: API.Client

        func create(
            entity: Permission.Add.Model
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .systemPermissionPost(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                key: entity.key,
                                name: entity.name,
                                notes: entity.notes
                            )
                        )
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
