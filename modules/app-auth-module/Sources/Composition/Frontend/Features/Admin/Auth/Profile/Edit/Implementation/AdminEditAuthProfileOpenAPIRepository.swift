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

struct AdminEditAuthProfileOpenAPIRepository:
    AdminEditAuthProfileRepository
{
    let api: UserAdminAPIClient

    func update(
        id: String,
        payload: AdminEditAuthProfileFormPayloadModel
    ) async throws {
        _ = payload
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userIdentityPatch(
                path: .init(userIdentityId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        status: nil,
                        roleIds: nil
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User identity not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to edit the profile."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot edit the profile."
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
