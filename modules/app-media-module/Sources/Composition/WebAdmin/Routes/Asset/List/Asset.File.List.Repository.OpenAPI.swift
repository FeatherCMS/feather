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

extension Asset.File.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func search(
            page: Int,
            search: String?,
            parentId: String?,
            allowedExtensions: [String]
        ) async throws -> Result {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let normalizedExtensions = Set(
                    allowedExtensions.map { $0.lowercased() }
                        .filter { !$0.isEmpty }
                )
                if normalizedExtensions.isEmpty {
                    let response = try await queryAssets(
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

        func resolveAssets(
            ids: [String],
            variants: [String]? = nil
        ) async throws -> [Components.Schemas.MediaAssetResolveItemSchema] {
            guard !ids.isEmpty else { return [] }

            return try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaAssetResolve(
                    .init(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(.init(ids: ids, variants: variants))
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
        }

        func getFolder(
            id: String
        ) async throws -> Asset.Folder.Detail.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .mediaFolderGet(
                        path: .init(mediaFolderId: id)
                    )
                switch response {
                case .ok(let ok):
                    let folder = try ok.body.json
                    return Asset.Folder.Detail.Model(
                        id: folder.id,
                        parentId: folder.parentId,
                        name: folder.name,
                        slug: folder.slug,
                        slugPath: folder.slugPath,
                        assetCount: folder.assetCount,
                        totalSizeBytes: folder.totalSizeBytes
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

extension Asset.File.List.Repository.OpenAPI {

    fileprivate func queryAssets(
        page: Int,
        size: Int,
        search: String?,
        parentId: String?
    ) async throws -> Asset.File.List.Repository.Result {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaAssetQuery(
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
    ) async throws -> [Components.Schemas.MediaAssetNodeQueryItemSchema] {
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
    ) async throws -> [Components.Schemas.MediaAssetNodeQueryItemSchema] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let backendPageSize = 200
            var backendPage = 1
            var items: [Components.Schemas.MediaAssetNodeQueryItemSchema] = []
            var total = 0

            while true {
                let response = try await queryAssets(
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
