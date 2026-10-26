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

extension Credential.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        let userAPI: UserWebAdmin.API.Client

        func listEmails() async throws -> [Credential.Form.IdentityOption] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.authEmailList(
                    headers: .init(accept: [.init(contentType: .json)]),
                )
                switch response {
                case .ok(let ok):
                    let body = try ok.body.json
                    return body.map {
                        .init(id: String($0.email), label: $0.email)
                    }
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

        func create(payload: Credential.Form.Payload) async throws {
            guard let password = payload.password else { return }
            let emails = try await listEmailDetails()
            guard
                let selectedEmail = emails.first(where: {
                    $0.email == payload.email
                })
            else {
                throw OpenAPIRepositoryError.notFound
            }
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.authCredentialCreate(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            userId: selectedEmail.identityId,
                            email: selectedEmail.email,
                            password: password
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

        private func listEmailDetails() async throws
            -> [Email.Option]
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.authEmailList(
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let ok):
                    return try ok.body.json.map {
                        .init(id: $0.id, identityId: $0.identityId, email: $0.email)
                    }
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
