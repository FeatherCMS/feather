import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension Credential.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        let userAPI: UserWebAdmin.API.Client

        func listEmails() async throws -> [Email.Option]
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.authEmailList(
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let value):
                    return try value.body.json.map {
                        .init(id: $0.id, identityId: $0.identityId, email: $0.email)
                    }
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let status, let body):
                    throw try await api.failure(
                        statusCode: status,
                        responseBody: body.body
                    )
                }
            }
        }

        func get(id: String) async throws -> Credential.Edit.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.authCredentialGet(
                    path: .init(authCredentialId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let ok):
                    let item = try ok.body.json
                    return .init(
                        id: item.id,
                        userId: item.userId,
                        email: item.email
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

        func update(id: String, payload: Credential.Form.Payload)
            async throws
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.authCredentialPatch(
                    path: .init(authCredentialId: id),
                    query: .init(updateMask: "userId,email,password"),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            userId: payload.userId,
                            email: payload.email,
                            password: payload.password
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
