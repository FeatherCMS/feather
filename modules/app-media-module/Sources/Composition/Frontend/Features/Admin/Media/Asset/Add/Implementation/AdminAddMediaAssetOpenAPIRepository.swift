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
        payload: AssetAddForm
    ) async throws -> Components.Schemas.MediaAssetDetailSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaAssetCreate(
                    body: .json(
                        .init(
                            parentId: payload.parentId
                                .whitespaceTrimmed
                                .emptyToNil,
                            fileName: payload.fileName.whitespaceTrimmed,
                            _extension: payload.extension.whitespaceTrimmed,
                            title: payload.title.emptyToNil,
                            altText: payload.altText.emptyToNil,
                            data: payload.data.whitespaceTrimmed
                        )
                    )
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
