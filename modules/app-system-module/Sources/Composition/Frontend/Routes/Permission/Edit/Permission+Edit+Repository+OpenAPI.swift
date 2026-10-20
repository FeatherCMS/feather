import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Permission.Edit.Repository {
    struct OpenAPI:
        WebAdmin.System.Permission.Edit.Repository.Interface
    {
        let api: SystemAdminAPIClient

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
                        key: permission.key,
                        name: permission.name,
                        notes: permission.notes
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
            input: SystemPermissionEditFormInput
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.systemPermissionPut(
                    path: .init(systemPermissionId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            key: input.normalizedKey,
                            name: input.normalizedName,
                            notes: input.normalizedNotes
                        )
                    )
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
