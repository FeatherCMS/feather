import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func getAsset(
            id: String
        ) async throws
            -> Asset.File.Edit.Model
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .mediaAssetGet(
                        path: .init(mediaAssetId: id)
                    )
                switch response {
                case .ok(let ok):
                    let asset = try ok.body.json
                    return Asset.File.Edit.Model(
                        id: asset.id,
                        title: asset.title ?? "",
                        altText: asset.altText ?? "",
                        error: nil
                    )
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
        ) async throws -> Asset.File.Edit.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .mediaAssetPatch(
                        path: .init(mediaAssetId: id),
                        query: .init(updateMask: "title,altText"),
                        body: .json(
                            .init(
                                title: title,
                                altText: altText
                            )
                        )
                    )
                switch response {
                case .ok(let ok):
                    let asset = try ok.body.json
                    return Asset.File.Edit.Model(
                        id: asset.id,
                        title: asset.title ?? "",
                        altText: asset.altText ?? "",
                        error: nil
                    )
                case .badRequest(let response):
                    let data = try JSONEncoder().encode(try response.body.json)
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(data: data, encoding: .utf8)
                    )
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
}
