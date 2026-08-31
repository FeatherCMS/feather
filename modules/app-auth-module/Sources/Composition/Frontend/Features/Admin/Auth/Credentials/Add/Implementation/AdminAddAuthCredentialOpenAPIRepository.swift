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

    func create(userId: String, payload: AuthCredentialFormPayloadModel)
        async throws
    {
        guard let password = payload.password else { return }
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.authCredentialCreate(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        userId: userId,
                        email: payload.email,
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
}
