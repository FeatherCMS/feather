import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminMediaAssetOpenAPIRepository {
    let api: AdminAPI
    private let listFoldersUnauthorizedMessage =
        "Please sign in again to view media folders."
    private let createFolderUnauthorizedMessage =
        "Please sign in again to create a media folder."
    private let getFolderUnauthorizedMessage =
        "Please sign in again to load this media folder."
    private let updateFolderUnauthorizedMessage =
        "Please sign in again to update this media folder."
    private let deleteFolderUnauthorizedMessage =
        "Please sign in again to delete this media folder."
    private let getAssetUnauthorizedMessage =
        "Please sign in again to load this media asset."
    private let getVariantsUnauthorizedMessage =
        "Please sign in again to load this media asset's variants."
    private let createAssetUnauthorizedMessage =
        "Please sign in again to create this media asset."
    private let deleteAssetUnauthorizedMessage =
        "Please sign in again to delete this media asset."
    private let updateAssetUnauthorizedMessage =
        "Please sign in again to update this media asset."
    private let searchAssetsUnauthorizedMessage =
        "Please sign in again to view media assets."

    func listAssets(
        page: Int,
        search: String?,
        parentId: String?,
        allowedExtensions: [String]
    ) async throws -> (
        items: [Components.Schemas.MediaAssetListItemSchema], total: Int,
        page: Int, pageSize: Int
    ) {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let normalizedExtensions = Set(
                allowedExtensions.map { $0.lowercased() }.filter { !$0.isEmpty }
            )
            if normalizedExtensions.isEmpty {
                let response = try await searchAssets(
                    page: page,
                    pageSize: 20,
                    search: search,
                    parentId: parentId
                )
                return (
                    items: response.items,
                    total: response.total,
                    page: response.page,
                    pageSize: response.pageSize
                )
            }

            let filteredItems = try await loadFilteredAssets(
                search: search,
                parentId: parentId,
                allowedExtensions: normalizedExtensions
            )
            let pageSize = 20
            let pageNumber = max(1, page)
            let startIndex = (pageNumber - 1) * pageSize
            let endIndex = min(startIndex + pageSize, filteredItems.count)
            let items =
                startIndex < filteredItems.count
                ? Array(filteredItems[startIndex..<endIndex])
                : []
            return (
                items: items,
                total: filteredItems.count,
                page: pageNumber,
                pageSize: pageSize
            )
        }
    }

    func listFolders(
        parentId: String?
    ) async throws -> [Components.Schemas.MediaFolderListItemSchema] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaFolderSearch(
                    body: .json(
                        .init(
                            page: .init(size: 100, number: 1),
                            sort: [.init(field: .name, direction: .asc)],
                            filters: .init(parentId: parentId)
                        )
                    )
                )
            switch response {
            case .ok(let ok):
                return try ok.body.json.data.items
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: listFoldersUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access media folders."
                )
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
    ) async throws -> Components.Schemas.MediaFolderDetailSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaFolderCreate(
                    body: .json(.init(parentId: parentId, name: name))
                )
            switch response {
            case .created(let created):
                return try created.body.json
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: createFolderUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create media folders."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func getFolder(
        id: String
    ) async throws -> Components.Schemas.MediaFolderDetailSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaFolderGet(path: .init(mediaFolderId: id))
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Media folder not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: getFolderUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access media folders."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func updateFolder(
        id: String,
        name: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaFolderUpdate(
                path: .init(mediaFolderId: id),
                body: .json(.init(name: name))
            )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Media folder not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: updateFolderUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit media folders."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func deleteFolder(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaFolderDelete(
                path: .init(mediaFolderId: id)
            )
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Media folder not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: deleteFolderUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete media folders."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func getAsset(
        id: String
    ) async throws -> Components.Schemas.MediaAssetDetailSchema {
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
                throw OpenAPIRepositoryError.notFound(
                    message: "Media asset not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: getAssetUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access media assets."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func getVariants(
        id: String
    ) async throws -> [Components.Schemas.MediaAssetVariantListItemSchema] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaAssetVariantSearch(
                    path: .init(mediaAssetId: id)
                )
            switch response {
            case .ok(let ok):
                return try ok.body.json.items
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Media asset not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: getVariantsUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access media asset variants."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

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
                                .trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                )
                                .nilIfEmpty,
                            fileName: payload.fileName.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ),
                            _type: payload.type.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ),
                            title: payload.title.nilIfEmpty,
                            altText: payload.altText.nilIfEmpty,
                            data: payload.data.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                        )
                    )
                )
            switch response {
            case .created(let created):
                return try created.body.json
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: createAssetUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create media assets."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func deleteAsset(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaAssetDelete(
                    path: .init(mediaAssetId: id)
                )
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Media asset not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: deleteAssetUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete media assets."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func delete(
        id: String
    ) async throws {
        try await deleteAsset(id: id)
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
                throw OpenAPIRepositoryError.notFound(
                    message: "Media asset not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: updateAssetUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit media assets."
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

extension AdminMediaAssetOpenAPIRepository {

    fileprivate func searchAssets(
        page: Int,
        pageSize: Int,
        search: String?,
        parentId: String?
    ) async throws -> (
        items: [Components.Schemas.MediaAssetListItemSchema], total: Int,
        page: Int, pageSize: Int
    ) {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaAssetSearch(
                    body: .json(
                        .init(
                            page: .init(size: pageSize, number: page),
                            sort: [.init(field: .createdAt, direction: .desc)],
                            filters: .init(search: search, parentId: parentId)
                        )
                    )
                )
            switch response {
            case .ok(let ok):
                let body = try ok.body.json
                return (
                    items: body.data.items,
                    total: body.data.total,
                    page: body.query.page.number,
                    pageSize: body.query.page.size
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: searchAssetsUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access media assets."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    fileprivate func loadFilteredAssets(
        search: String?,
        parentId: String?,
        allowedExtensions: Set<String>
    ) async throws -> [Components.Schemas.MediaAssetListItemSchema] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let items = try await loadAllAssets(
                search: search,
                parentId: parentId
            )
            let filteredItems =
                allowedExtensions.isEmpty
                ? items
                : items.filter {
                    allowedExtensions.contains($0._type.lowercased())
                }
            return filteredItems.sorted {
                $0.createdAt > $1.createdAt
            }
        }
    }

    fileprivate func loadAllAssets(
        search: String?,
        parentId: String?
    ) async throws -> [Components.Schemas.MediaAssetListItemSchema] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let backendPageSize = 200
            var backendPage = 1
            var items: [Components.Schemas.MediaAssetListItemSchema] = []
            var total = 0

            while true {
                let response = try await searchAssets(
                    page: backendPage,
                    pageSize: backendPageSize,
                    search: search,
                    parentId: parentId
                )
                total = response.total
                items.append(contentsOf: response.items)
                if items.count >= total
                    || response.items.count < backendPageSize
                {
                    break
                }
                backendPage += 1
            }
            return items
        }
    }
}
