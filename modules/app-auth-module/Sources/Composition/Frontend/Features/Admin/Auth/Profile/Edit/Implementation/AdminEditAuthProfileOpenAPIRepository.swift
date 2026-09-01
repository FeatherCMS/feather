import AuthAdminAPI
import CSS
import FeatherAdmin
import OpenAPIRuntime

struct AdminEditAuthProfileOpenAPIRepository:
    AdminEditAuthProfileRepository
{
    let api: AuthAdminAPIClient

    func update(
        id: String,
        payload: AdminEditAuthProfileFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let searchResponse = try await client.authCredentialSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: 1, number: 1),
                        filters: .init(search: nil, userId: id)
                    )
                )
            )
            let credentialID: String
            switch searchResponse {
            case .ok(let value):
                guard let credential = try value.body.json.data.items.first
                else {
                    throw OpenAPIRepositoryError.notFound(
                        message: "User credential not found."
                    )
                }
                credentialID = credential.id
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to update the profile."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot update the profile."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }

            let response = try await client.authCredentialPatch(
                path: .init(authCredentialId: credentialID),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
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
                    message: "Please sign in again to update the profile."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot update the profile."
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
