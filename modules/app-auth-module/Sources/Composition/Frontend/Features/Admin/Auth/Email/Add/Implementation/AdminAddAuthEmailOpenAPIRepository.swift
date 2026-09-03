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

struct AdminAddAuthEmailOpenAPIRepository:
    AdminAddAuthEmailRepository
{
    let api: AuthAdminAPIClient
    let userAPI: UserAdminAPIClient

    func listIdentities() async throws -> [AuthCredentialIdentityOption] {
        try await userAPI.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userIdentitySearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(.init(
                    page: .init(size: 100, number: 1),
                    filters: .init(search: nil)
                ))
            )
            switch response {
            case .ok(let value):
                return try value.body.json.data.items.map {
                    .init(id: String($0.id), label: $0.name)
                }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view user identities."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot access user identities."
                )
            case .undocumented(let status, let body):
                throw try await userAPI.failure(
                    statusCode: status,
                    responseBody: body.body
                )
            }
        }
    }

    func create(
        payload: AuthEmailFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .authEmailCreate(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            identityId: payload.identityId,
                            email: payload.email
                        )
                    )
                )
            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to create this user email."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your identity cannot create user emails."
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
