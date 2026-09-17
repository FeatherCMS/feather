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
                        page: response.pageState.page,
                        pageSize: response.pageState.pageSize,
                        total: response.pageState.total
                    )
                )
            }

            let filteredItems = try await loadFilteredItems(
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
                .mediaFolderList(
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

    func resolveAssets(
        ids: [String]
    ) async throws -> [Components.Schemas.MediaAssetResolveItemSchema] {
        try await api.resolveAssets(ids: ids)
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

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.mediaAssetNodeRemove(
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
                .mediaAssetList(
                    body: .json(
                        .init(
                            page: .init(size: size, number: page),
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

    fileprivate func loadFilteredItems(
        search: String?,
        parentId: String?,
        allowedExtensions: Set<String>
    ) async throws -> [Components.Schemas.MediaAssetNodeSearchItemSchema] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let items = try await loadAllItems(
                search: search,
                parentId: parentId
            )
            return items.filter { item in
                guard let asset = item.file else { return true }
                return allowedExtensions.contains(asset._extension.lowercased())
            }
        }
    }

    fileprivate func loadAllItems(
        search: String?,
        parentId: String?
    ) async throws -> [Components.Schemas.MediaAssetNodeSearchItemSchema] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let backendPageSize = 200
            var backendPage = 1
            var items: [Components.Schemas.MediaAssetNodeSearchItemSchema] = []
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
                if response.items.count < response.pageState.pageSize
                    || response.pageState.page * response.pageState.pageSize
                        >= total
                {
                    break
                }
                backendPage += 1
            }
            return items
        }
    }
}
