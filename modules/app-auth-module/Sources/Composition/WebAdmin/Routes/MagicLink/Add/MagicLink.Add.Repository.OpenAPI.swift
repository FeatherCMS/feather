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

extension MagicLink.Add.Repository {
    struct OpenAPI:
        MagicLink.Add.Repository.Interface
    {
        let api: API.Client

        func listEmails() async throws
            -> [AuthAdminAPI.Components.Schemas.AuthEmailSchemasDetail]
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.authEmailList(
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let ok): return try ok.body.json
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

        func create(
            payload: MagicLink.Add.Payload
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .authMagicLinkCreate(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                credentialId: payload.credentialId,
                                isPersistent: payload.isPersistent
                            )
                        )
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
}
