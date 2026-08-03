import AdminOpenAPI
import Hummingbird

struct AdminEditAuthCredentialOpenAPIRepository: AdminEditAuthCredentialRepository {
    let api: AdminAPI

    func get(id: String) async throws -> AuthCredentialDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userCredentialGet(
                path: .init(userCredentialId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let ok):
                let item = try ok.body.json
                return .init(id: item.id, accountID: item.accountID, email: item.email)
            case .notFound:
                throw OpenAPIRepositoryError.notFound(message: "User credential not found.")
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to load this credential.")
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(message: "Your account cannot access credentials.")
            case .undocumented(let statusCode, let response):
                throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func update(id: String, payload: AuthCredentialFormPayloadModel) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userCredentialPatch(
                path: .init(userCredentialId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(.init(email: payload.email, password: payload.password))
            )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(message: "User credential not found.")
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to update this credential.")
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(message: "Your account cannot update credentials.")
            case .undocumented(let statusCode, let response):
                throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }
}
