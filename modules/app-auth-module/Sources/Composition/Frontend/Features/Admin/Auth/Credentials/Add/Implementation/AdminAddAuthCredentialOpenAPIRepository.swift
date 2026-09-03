import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

struct AdminAddAuthCredentialOpenAPIRepository: AdminAddAuthCredentialRepository
{
    let api: AuthAdminAPIClient
    let userAPI: UserAdminAPIClient

    func listEmails() async throws -> [AuthCredentialIdentityOption] {
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
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view auth emails."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot access auth emails."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func create(payload: AuthCredentialFormPayloadModel) async throws {
        guard let password = payload.password else { return }
        let emails = try await listEmailDetails()
        guard
            let selectedEmail = emails.first(where: {
                $0.email == payload.email
            })
        else {
            throw OpenAPIRepositoryError.notFound(
                message: "Auth email not found."
            )
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
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to create credentials."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot create credentials."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private func listEmailDetails() async throws
        -> [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema]
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.authEmailList(
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let ok): return try ok.body.json
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view auth emails."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot access auth emails."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
