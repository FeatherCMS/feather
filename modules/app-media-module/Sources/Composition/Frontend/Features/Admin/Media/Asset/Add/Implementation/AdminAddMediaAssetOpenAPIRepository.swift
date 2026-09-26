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
        payload: AssetAddUpload
    ) async throws -> Components.Schemas.MediaAssetDetailSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
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
