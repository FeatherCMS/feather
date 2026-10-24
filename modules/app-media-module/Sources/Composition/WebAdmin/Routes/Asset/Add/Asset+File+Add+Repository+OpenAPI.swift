import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func listFolders(
            parentId: String?
        ) async throws -> [Components.Schemas.MediaFolderListItemSchema] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaFolderList(
                    .init(query: .init(parentId: parentId))
                )
                switch response {
                case .ok(let ok):
                    return try ok.body.json
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

        func createFolder(
            name: String,
            parentId: String?
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaFolderPost(
                    body: .json(.init(parentId: parentId, name: name))
                )
                switch response {
                case .created:
                    return
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .conflict:
                    throw OpenAPIRepositoryError.conflict
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }

        func createAsset(
            payload: Asset.File.Add.Upload.Payload,
            variants: [String]? = nil
        ) async throws -> AdminMediaAsset {
            let asset: Components.Schemas.MediaAssetDetailSchema =
                try await api
                .withOpenAPIRepositoryErrorMapping { client in
                    let response =
                        try await client
                        .mediaAssetPost(
                            headers: .init(
                                xMediaAssetParentID: payload.parentId
                                    .whitespaceTrimmed
                                    .emptyToNil,
                                xMediaAssetFileName: payload.fileName
                                    .whitespaceTrimmed,
                                xMediaAssetExtension: payload.extension
                                    .whitespaceTrimmed,
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

            let resolvedVariants: [AdminMediaAssetVariant]
            if let variants, !variants.isEmpty {
                let resolved = try await api.withOpenAPIRepositoryErrorMapping {
                    client in
                    let response = try await client.mediaAssetResolve(
                        .init(
                            headers: .init(accept: [.init(contentType: .json)]),
                            body: .json(
                                .init(ids: [asset.id], variants: variants)
                            )
                        )
                    )
                    switch response {
                    case .ok(let ok):
                        return try ok.body.json
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
                resolvedVariants =
                    resolved
                    .first(where: { $0.id == asset.id })?
                    .variants
                    .map {
                        AdminMediaAssetVariant(
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

            return AdminMediaAsset(
                schema: asset,
                variants: resolvedVariants
            )
        }
    }
}
