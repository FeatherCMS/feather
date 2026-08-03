import AdminOpenAPI
import Hummingbird

struct AdminRemoveAuthCredentialOpenAPIRepository: AdminRemoveAuthCredentialRepository {
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

    func delete(id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userCredentialDelete(path: .init(userCredentialId: id))
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(message: "User credential not found.")
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to delete this credential.")
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(message: "Your account cannot delete credentials.")
            case .undocumented(let statusCode, let response):
                throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }
}
