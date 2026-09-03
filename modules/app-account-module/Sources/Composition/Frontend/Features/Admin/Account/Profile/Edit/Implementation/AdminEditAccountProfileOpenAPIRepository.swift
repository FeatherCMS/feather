import AccountAdminAPI
import FeatherAdmin
import OpenAPIRuntime

struct AdminEditAccountProfileOpenAPIRepository:
    AdminEditAccountProfileRepository
{
    let api: AccountAdminAPIClient

    func load(userID: String) async throws -> AdminEditAccountProfileModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.adminAccountProfileGet(
                .init(
                    path: .init(userId: userID),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            )
            switch response {
            case .ok(let value):
                let body = try value.body.json
                return .init(
                    firstName: body.firstName,
                    lastName: body.lastName,
                    profileImageAssetId: body.profileImageAssetId
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load this profile."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access this profile."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func save(
        userID: String,
        input: AdminEditAccountProfileFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.adminAccountProfileUpdate(
                .init(
                    path: .init(userId: userID),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            firstName: input.firstName,
                            lastName: input.lastName,
                            profileImageAssetId: input.profileImageAssetId
                        )
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to save this profile."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit this profile."
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
