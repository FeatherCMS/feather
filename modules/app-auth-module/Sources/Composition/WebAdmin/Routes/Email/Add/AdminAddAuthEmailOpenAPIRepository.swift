import AuthAdminAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

struct AdminAddAuthEmailOpenAPIRepository:
    AdminAddAuthEmailRepository
{
    let api: API.Client
    let userAPI: UserWebAdmin.API.Client

    func listIdentities() async throws -> [AuthCredentialIdentityOption] {
        try await userAPI.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userIdentityList(
                query: .init(limit: 100),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let value):
                return try value.body.json.map {
                    .init(id: String($0.id), label: $0.name)
                }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden
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
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
