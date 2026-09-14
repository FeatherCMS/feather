import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListMediaAssetOpenAPIRepository {
    let api: MediaAdminAPIClient

    func listAssets(
        page: Int,
        search: String?,
        parentId: String?,
        allowedExtensions: [String]
    ) async throws -> AdminListMediaAssetRepositoryResult {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let normalizedExtensions = Set(
                allowedExtensions.map { $0.lowercased() }.filter { !$0.isEmpty }
            )
            if normalizedExtensions.isEmpty {
                let response = try await searchAssets(
                    page: page,
                    size: 20,
                    search: search,
                    parentId: parentId
                )
                return .init(
                    items: response.items,
                    pageState: .init(
                        page: response.page,
                        pageSize: response.pageSize,
                        total: response.total
                    )
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
            return .init(
                items: items,
                pageState: .init(
                    page: pageNumber,
                    pageSize: pageSize,
                    total: filteredItems.count
                )
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

    func getFolder(
        id: String
    ) async throws -> Components.Schemas.MediaFolderDetailSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaFolderGet(
                    path: .init(mediaFolderId: id)
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

    func deleteFolder(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.mediaFolderDelete(
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.mediaAssetDelete(
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }
}

extension AdminListMediaAssetOpenAPIRepository {

    fileprivate func searchAssets(
        page: Int,
        size: Int,
        search: String?,
        parentId: String?
    ) async throws -> AdminListMediaAssetRepositoryResult {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaAssetSearch(
                    body: .json(
                        .init(
                            page: .init(size: size, number: page),
                            sort: [.init(field: .createdAt, direction: .desc)],
                            filters: .init(search: search, parentId: parentId)
                        )
                    )
                )
            switch response {
            case .ok(let ok):
                let body = try ok.body.json
                return .init(
                    items: body.data.items,
                    pageState: .init(
                        page: body.query.page.number,
                        pageSize: body.query.page.size,
                        total: body.data.total
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
                    size: backendPageSize,
                    search: search,
                    parentId: parentId
                )
                total = response.pageState.total
                items.append(contentsOf: response.items)
                if items.count >= total
                    || response.items.count < response.pageState.pageSize
                {
                    break
                }
                backendPage += 1
            }
            return items
        }
    }
}
