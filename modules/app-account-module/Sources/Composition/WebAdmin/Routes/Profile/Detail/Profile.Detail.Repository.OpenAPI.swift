import AccountAdminAPI
import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import MediaModule
import MediaWebAdmin
import OpenAPIRuntime

extension Profile.Detail.Repository {

    struct OpenAPI: Interface {
        let api: API.Client
        let mediaRepository:
            any MediaModule.Asset.File.View.Repository.Interface

        func get() async throws -> Profile.Remote.Model {
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
                        profileImageAsset:
                            try await mediaRepository.loadImageAsset(
                                assetId: body.profileImageAssetId,
                                variants: ["preview"]
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

    }
}
