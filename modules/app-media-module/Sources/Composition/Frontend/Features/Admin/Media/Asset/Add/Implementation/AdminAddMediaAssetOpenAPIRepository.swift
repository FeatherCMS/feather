import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddMediaAssetOpenAPIRepository {
    let api: MediaAdminAPIClient

    func createAsset(
        payload: AssetAddUpload,
        variants: [String]? = nil
    ) async throws -> NewAdminMediaAsset {
        let asset: Components.Schemas.MediaAssetDetailSchema = try await api
            .withOpenAPIRepositoryErrorMapping { client in
                let response = try await client
                    .mediaAssetCreate(
                        headers: .init(
                            xMediaAssetParentID: payload.parentId
                                .whitespaceTrimmed
                                .emptyToNil,
                            xMediaAssetFileName: payload.fileName.whitespaceTrimmed,
                            xMediaAssetExtension: payload.extension.whitespaceTrimmed,
                            xMediaAssetTitle: payload.title.emptyToNil,
                            xMediaAssetAltText: payload.altText.emptyToNil
                        ),
                        body: .binary(payload.content)
                    )
                switch response {
                case .created(let created):
                    return try created.body.json
                case .conflict:
                    throw OpenAPIRepositoryError.conflict
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

        let resolvedVariants: [NewAdminMediaAssetVariant]
        if let variants, !variants.isEmpty {
            let resolved = try await api.resolveAssets(
                ids: [asset.id],
                variants: variants
            )
            resolvedVariants = resolved
                .first(where: { $0.id == asset.id })?
                .variants
                .map {
                    NewAdminMediaAssetVariant(
                        key: $0.key,
                        name: $0.name,
                        url: $0.url,
                        extension: $0._extension
                    )
                } ?? []
        }
        else {
            resolvedVariants = []
        }

        return NewAdminMediaAsset(
            schema: asset,
            variants: resolvedVariants
        )
    }
}
