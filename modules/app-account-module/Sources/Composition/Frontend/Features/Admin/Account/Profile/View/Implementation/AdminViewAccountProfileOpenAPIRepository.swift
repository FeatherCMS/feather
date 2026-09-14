import AccountAppAPI
import FeatherAdmin
import MediaFrontend
import OpenAPIRuntime

struct AdminViewAccountProfileOpenAPIRepository:
    AdminViewAccountProfileRepository
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
                    profileImageAsset: try await loadImageAsset(
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

    private func loadImageAsset(
        assetId: String?
    ) async throws -> AdminMediaAssetReferenceModel? {
        guard let assetId, !assetId.isEmpty else { return nil }
        let asset = try? await AdminViewMediaAssetOpenAPIRepository(
            api: mediaAPI
        )
        .getAsset(id: assetId)
        return asset.map(AdminMediaAssetReferenceModel.init(schema:))
    }

}
