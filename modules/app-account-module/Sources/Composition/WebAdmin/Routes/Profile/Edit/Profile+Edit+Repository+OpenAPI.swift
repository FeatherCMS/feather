import AccountAdminAPI
import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import MediaWebAdmin
import OpenAPIRuntime

extension Profile.Edit.Repository {

    struct OpenAPI:
        Profile.Edit.Repository.Interface
    {
        let api: API.Client
        let mediaAPI: MediaWebAdmin.API.Client

        func get() async throws -> Profile.WebAdminModel {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.accountCurrentUserProfileGet(
                    headers: .init(accept: [.init(contentType: .json)])
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
            profile: Profile.WebAdminModel
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.accountCurrentUserProfileUpdate(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            firstName: profile.firstName,
                            lastName: profile.lastName,
                            profileImageAssetId: profile.profileImageAssetId
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
}
