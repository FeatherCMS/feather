import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditMediaAssetOpenAPIRepository {
    let api: MediaAdminAPIClient

    func getAsset(
        id: String
    ) async throws -> MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaAssetGet(
                    path: .init(mediaAssetId: id)
                )
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound:
                throw OpenAPIRepositoryError.notFound
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

    func updateAsset(
        id: String,
        title: String?,
        altText: String?
    ) async throws -> Components.Schemas.MediaAssetDetailSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaAssetUpdate(
                    path: .init(mediaAssetId: id),
                    body: .json(
                        .init(
                            title: title,
                            altText: altText
                        )
                    )
                )
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound:
                throw OpenAPIRepositoryError.notFound
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
