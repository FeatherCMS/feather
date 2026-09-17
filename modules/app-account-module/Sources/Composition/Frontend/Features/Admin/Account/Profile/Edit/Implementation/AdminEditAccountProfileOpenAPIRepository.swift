import AccountAppAPI
import FeatherAdmin
import MediaFrontend
import OpenAPIRuntime

struct AdminEditAccountProfileOpenAPIRepository:
    AdminEditAccountProfileRepository
{
    let api: AccountAppAPIClient
    let mediaAPI: MediaAdminAPIClient

    func get() async throws -> AdminAccountProfileModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.accountProfileGet(
                .init(headers: .init(accept: [.init(contentType: .json)]))
            )
            switch response {
            case .ok(let value):
                let body = try value.body.json
                return .init(
                    firstName: body.firstName,
                    lastName: body.lastName,
                    profileImageAssetId: body.profileImageAssetId,
                    profileImageAsset: try await mediaAPI.loadImageAsset(
                        assetId: body.profileImageAssetId
                    )
                )
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

    func update(
        profile: AdminAccountProfileModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.accountProfileUpdate(
                .init(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            firstName: profile.firstName,
                            lastName: profile.lastName,
                            profileImageAssetId: profile.profileImageAssetId
                        )
                    )
                )
            )
            switch response {
            case .ok:
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
