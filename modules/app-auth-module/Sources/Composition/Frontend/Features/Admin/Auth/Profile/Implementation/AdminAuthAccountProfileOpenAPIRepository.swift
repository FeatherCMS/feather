import AccountAppAPI
import FeatherAdmin
import MediaFrontend
import OpenAPIRuntime

struct AdminAuthAccountProfileOpenAPIRepository:
    AdminAuthAccountProfileRepository
{
    let api: AccountAppAPIClient
    let mediaAPI: MediaAdminAPIClient

    func get() async throws -> AdminAuthAccountProfileModel {
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
                    profileImageAsset: try await loadImageAsset(
                        assetId: body.profileImageAssetId
                    )
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load your profile."
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

    private func loadImageAsset(
        assetId: String?
    ) async throws -> AdminMediaAssetReferenceModel? {
        guard let assetId, !assetId.isEmpty else { return nil }
        let asset = try? await AdminMediaAssetOpenAPIRepository(
            api: mediaAPI
        ).getAsset(id: assetId)
        return asset.map(AdminMediaAssetReferenceModel.init(schema:))
    }

    func update(
        profile: AdminAuthAccountProfileModel
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
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to save your profile."
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
