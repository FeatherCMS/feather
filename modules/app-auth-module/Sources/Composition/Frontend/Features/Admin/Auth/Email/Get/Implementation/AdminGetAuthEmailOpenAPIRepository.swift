import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
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

struct AdminGetAuthEmailOpenAPIRepository:
    AdminGetAuthEmailRepository
{
    let api: AuthAdminAPIClient

    func get(
        id: String
    ) async throws -> AuthEmailDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .authEmailGet(
                    path: .init(authEmailId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            switch response {
            case .ok(let ok):
                let item = try ok.body.json
                return .init(
                    id: item.id,
                    identityId: item.identityId,
                    email: item.email
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User email not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to load this user email."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your identity cannot access user emails."
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
