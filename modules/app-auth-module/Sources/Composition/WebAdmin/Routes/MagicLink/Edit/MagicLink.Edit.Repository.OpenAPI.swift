import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
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

extension MagicLink.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

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

        func get(
            id: String
        ) async throws -> MagicLink.View.Detail {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .authMagicLinkGet(
                        path: .init(authMagicLinkId: id),
                        headers: .init(accept: [.init(contentType: .json)])
                    )
                switch response {
                case .ok(let ok):
                    let item = try ok.body.json
                    return .init(
                        id: item.id,
                        credentialId: item.credentialId,
                        isPersistent: item.isPersistent
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
            payload: MagicLink.Add.Payload
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .authMagicLinkUpdate(
                        path: .init(authMagicLinkId: id),
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                credentialId: payload.credentialId,
                                isPersistent: payload.isPersistent
                            )
                        )
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
}
