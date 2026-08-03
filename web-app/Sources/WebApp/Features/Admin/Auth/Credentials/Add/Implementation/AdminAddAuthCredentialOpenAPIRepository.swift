import AdminOpenAPI
import Hummingbird

struct AdminAddAuthCredentialOpenAPIRepository: AdminAddAuthCredentialRepository {
    let api: AdminAPI

    func create(accountID: String, payload: AuthCredentialFormPayloadModel) async throws {
        guard let password = payload.password else { return }
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userCredentialCreate(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(.init(accountID: accountID, email: payload.email, password: password))
            )
            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to create credentials.")
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(message: "Your account cannot create credentials.")
            case .undocumented(let statusCode, let response):
                throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }
}
