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

extension Email.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        let userAPI: UserWebAdmin.API.Client

        func listIdentities() async throws -> [Credential.Form.IdentityOption] {
            try await Email.Add.Repository
                .OpenAPI(
                    api: api,
                    userAPI: userAPI
                )
                .listIdentities()
        }

        func get(
            id: String
        ) async throws -> Email.View.Detail {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .authEmailGet(
                        path: .init(authEmailId: id),
                        headers: .init(accept: [.init(contentType: .json)])
                    )
                switch response {
                case .ok(let ok):
                    let item = try ok.body.json
                    return .init(
                        id: item.id,
                        identityId: item.identityId,
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

        func update(
            id: String,
            payload: Email.Form.Payload
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .authEmailPatch(
                        path: .init(authEmailId: id),
                        query: .init(updateMask: "identityId,email"),
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                identityId: payload.identityId,
                                email: payload.email
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
