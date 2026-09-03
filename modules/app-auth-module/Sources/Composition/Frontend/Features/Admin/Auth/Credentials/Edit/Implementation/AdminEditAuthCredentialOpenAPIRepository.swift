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

struct AdminEditAuthCredentialOpenAPIRepository:
    AdminEditAuthCredentialRepository
{
    let api: AuthAdminAPIClient
    let userAPI: UserAdminAPIClient

    func listIdentities() async throws -> [AuthCredentialIdentityOption] {
        try await AdminAddAuthCredentialOpenAPIRepository(api: api, userAPI: userAPI)
            .listIdentities()
    }

    func get(id: String) async throws -> AuthCredentialDetailsModel {
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
                throw OpenAPIRepositoryError.notFound(
                    message: "User credential not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load this credential."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot access credentials."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func update(id: String, payload: AuthCredentialFormPayloadModel)
        async throws
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.authCredentialPatch(
                path: .init(authCredentialId: id),
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
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User credential not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to update this credential."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot update credentials."
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
