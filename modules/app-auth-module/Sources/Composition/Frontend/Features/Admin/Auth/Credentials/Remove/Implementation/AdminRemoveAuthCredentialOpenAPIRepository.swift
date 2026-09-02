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

struct AdminRemoveAuthCredentialOpenAPIRepository:
    AdminRemoveAuthCredentialRepository
{
    let api: AuthAdminAPIClient

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

    func delete(id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.authCredentialDelete(
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }
}
