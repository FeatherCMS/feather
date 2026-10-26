import FeatherApplication
import FeatherModuleKit
import Foundation
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    public func mediaAssetQuery(
        _ input: Operations.MediaAssetQuery.Input
    ) async throws -> Operations.MediaAssetQuery.Output {
        let query:
            Components.Schemas.MediaAssetNodeQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeSearchAssets()
        let objectQuery = mapAssetSearchQuery(query)
        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: assetSearchResponseQuery(from: query),
                        data: .init(
                            items: result.items.map(mapAssetSearchItem),
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    private func mapAssetSearchQuery(
        _ query: Components.Schemas.MediaAssetNodeQueryItemSearchRequestQuerySchema
    ) -> Asset.File.Search.Input.Query {
        let page = query.page ?? .init()
        return .init(
            page: .init(size: page.size ?? 20, number: page.number ?? 1),
            sort: (query.sort ?? []).map { rule in
                let field: Asset.File.Search.Input.Query.Sort.Field
                switch rule.field {
                case .id: field = .id
                case .name: field = .name
                case .slugPath: field = .slugPath
                case ._extension: field = .extension
                case .sizeBytes: field = .sizeBytes
                case .status: field = .status
                case .title: field = .title
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                let direction: Search.SortDirection
                switch rule.direction {
                case .asc: direction = .asc
                case .desc: direction = .desc
                }
                return .init(field: field, direction: direction)
            },
            search: query.filters.search,
            parentId: (query.filters.parentId ?? "").emptyToNil
        )
    }

    private func assetSearchResponseQuery(
        from query: Components.Schemas.MediaAssetNodeQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas.MediaAssetNodeQueryItemSearchResponseQuerySchema {
        let page = query.page ?? .init()
        let sort = query.sort?.map { rule
            -> Components.Schemas.MediaAssetNodeQueryItemSearchResponseQuerySchema.SortPayloadPayload in
            let field: Components.Schemas
                .MediaAssetNodeQueryItemSearchResponseQuerySchema
                .SortPayloadPayload.FieldPayload
            switch rule.field {
            case .id: field = .id
            case .name: field = .name
            case .slugPath: field = .slugPath
            case ._extension: field = ._extension
            case .sizeBytes: field = .sizeBytes
            case .status: field = .status
            case .title: field = .title
            case .createdAt: field = .createdAt
            case .updatedAt: field = .updatedAt
            }
            return .init(field: field, direction: rule.direction)
        }
        return .init(
            page: .init(size: page.size ?? 20, number: page.number ?? 1),
            sort: sort,
            filters: .init(
                search: query.filters.search,
                parentId: query.filters.parentId
            )
        )
    }

    private func mapAssetSearchItem(
        _ item: Asset.File.Search.Output.Item
    ) -> Components.Schemas.MediaAssetNodeQueryItemSchema {
        switch item {
        case .asset(let asset):
            return .init(kind: "file", file: mapAssetSearchFile(asset))
        case .folder(let folder):
            return .init(kind: "folder", folder: mapAssetSearchFolder(folder))
        }
    }

    private func mapAssetSearchFile(
        _ item: Asset.File.Search.Output.AssetItem
    ) -> Components.Schemas.MediaAssetQueryItemFileSchema {
        .init(
            id: item.id,
            folderId: item.folderId,
            name: item.name,
            slug: item.slug,
            slugPath: item.slugPath,
            url: mediaResolver.resolve(imagePath: item.url) ?? item.url,
            _extension: item.extension,
            contentType: item.contentType,
            sizeBytes: item.sizeBytes,
            status: item.status,
            title: item.title,
            altText: item.altText,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    private func mapAssetSearchFolder(
        _ item: Asset.File.Search.Output.FolderItem
    ) -> Components.Schemas.MediaAssetQueryItemFolderSchema {
        .init(
            id: item.id,
            parentId: item.parentId,
            name: item.name,
            slug: item.slug,
            slugPath: item.slugPath,
            assetCount: item.assetCount,
            totalSizeBytes: item.totalSizeBytes,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
