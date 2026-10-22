import FeatherApplication
import FeatherModuleKit
import Foundation
import MediaAdminAPI
import MediaApplication
import MediaDomain
import MediaModule

extension AdminAPIGateway {
    func mapSortDirection(
        _ direction: MediaAdminAPI.Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }
    func map(_ page: MediaAdminAPI.Components.Schemas.SearchPageSchema)
        -> Search.Page
    { .init(size: page.size ?? 20, number: page.number ?? 1) }

    func map(
        _ query: MediaAdminAPI.Components.Schemas
            .MediaAssetNodeQueryItemSearchRequestQuerySchema
    ) -> Asset.File.Search.Input.Query {
        let sort = (query.sort ?? [])
            .map { rule -> Asset.File.Search.Input.Query.Sort in
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
                return .init(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }
        return .init(
            page: map(query.page ?? .init()),
            sort: sort,
            search: query.filters.search,
            parentId: (query.filters.parentId ?? "").emptyToNil
        )
    }

    func responseQuery(
        from query: MediaAdminAPI.Components.Schemas
            .MediaAssetNodeQueryItemSearchRequestQuerySchema
    )
        -> MediaAdminAPI.Components.Schemas
        .MediaAssetNodeQueryItemSearchResponseQuerySchema
    {
        let page = map(query.page ?? .init())
        let sort = query.sort?
            .map { rule in
                let field:
                    MediaAdminAPI.Components.Schemas
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
                return MediaAdminAPI.Components.Schemas
                    .MediaAssetNodeQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: rule.direction)
            }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(
                search: query.filters.search,
                parentId: query.filters.parentId
            )
        )
    }

    func responseQuery(
        from query: MediaAdminAPI.Components.Schemas
            .MediaFolderQueryItemSearchRequestQuerySchema
    )
        -> MediaAdminAPI.Components.Schemas
        .MediaFolderQueryItemSearchResponseQuerySchema
    {
        let page = map(query.page ?? .init())
        let sort = query.sort?
            .map { rule in
                let field:
                    MediaAdminAPI.Components.Schemas
                        .MediaFolderQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .id: field = .id
                case .name: field = .name
                case .path: field = .path
                case .assetCount: field = .assetCount
                case .totalSizeBytes: field = .totalSizeBytes
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                return MediaAdminAPI.Components.Schemas
                    .MediaFolderQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: rule.direction)
            }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(parentId: query.filters.parentId)
        )
    }

    func responseQuery(
        from query: MediaAdminAPI.Components.Schemas
            .MediaVariantQueryItemSearchRequestQuerySchema
    )
        -> MediaAdminAPI.Components.Schemas
        .MediaVariantQueryItemSearchResponseQuerySchema
    {
        let page = map(query.page ?? .init())
        let sort = query.sort?
            .map { rule in
                let field:
                    MediaAdminAPI.Components.Schemas
                        .MediaVariantQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .id: field = .id
                case .key: field = .key
                case .name: field = .name
                case .isRequired: field = .isRequired
                case .isActive: field = .isActive
                }
                return MediaAdminAPI.Components.Schemas
                    .MediaVariantQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: rule.direction)
            }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(search: query.filters.search)
        )
    }

    func responseQuery(
        from query: MediaAdminAPI.Components.Schemas
            .MediaVariantProcessorQueryItemSearchRequestQuerySchema
    )
        -> MediaAdminAPI.Components.Schemas
        .MediaVariantProcessorQueryItemSearchResponseQuerySchema
    {
        let page = map(query.page ?? .init())
        let sort = query.sort?
            .map { rule in
                let field:
                    MediaAdminAPI.Components.Schemas
                        .MediaVariantProcessorQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .id: field = .id
                case .name: field = .name
                case .matchExtensions: field = .matchExtensions
                case .commandTemplate: field = .commandTemplate
                case .isActive: field = .isActive
                }
                return MediaAdminAPI.Components.Schemas
                    .MediaVariantProcessorQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: rule.direction)
            }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(search: query.filters.search)
        )
    }

    func errorEnvelope(
        message: String,
        reason: String
    )
        -> MediaAdminAPI.Components.Schemas
        .DefaultHTTPErrorContentSchemaHTTPErrorEnvelopeSchema
    {
        .init(error: .init(message: message, reason: reason))
    }

    func map(_ detail: Asset.File.Detail.Output)
        -> MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema
    {
        .init(
            id: detail.id,
            folderId: detail.folderId,
            name: detail.name,
            slug: detail.slug,
            slugPath: detail.slugPath,
            url: mediaResolver.resolve(imagePath: detail.url) ?? detail.url,
            _extension: detail.extension,
            contentType: detail.contentType,
            sizeBytes: detail.sizeBytes,
            status: detail.status,
            title: detail.title,
            altText: detail.altText,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(_ item: Asset.File.Resolve.Output.Item)
        -> MediaAdminAPI.Components.Schemas.MediaAssetResolveItemSchema
    {
        .init(
            id: item.id,
            url: mediaResolver.resolve(imagePath: item.url) ?? item.url,
            _extension: item.extension,
            title: item.title,
            altText: item.altText,
            variants: item.variants.map {
                .init(
                    key: $0.key,
                    name: $0.name,
                    url: mediaResolver.resolve(imagePath: $0.url) ?? $0.url,
                    _extension: $0.extension
                )
            }
        )
    }

    func map(_ item: Asset.File.Search.Output.AssetItem)
        -> MediaAdminAPI.Components.Schemas.MediaAssetQueryItemFileSchema
    {
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

    func map(_ item: Asset.File.Search.Output.Item)
        -> MediaAdminAPI.Components.Schemas.MediaAssetNodeQueryItemSchema
    {
        switch item {
        case .asset(let item): return .init(kind: "file", file: map(item))
        case .folder(let item):
            return .init(kind: "folder", folder: mapAssetFolder(item))
        }
    }

    func map(_ item: MediaBackend.UseCases.AssociatedVariantFile)
        -> MediaAdminAPI.Components.Schemas.MediaAssetVariantListItemSchema
    {
        .init(
            variantId: item.variantId,
            name: item.name,
            _extension: item.extension,
            url: mediaResolver.resolve(imagePath: item.url) ?? item.url
        )
    }

    func map(_ detail: Asset.Folder.Detail.Output)
        -> MediaAdminAPI.Components.Schemas.MediaFolderDetailSchema
    {
        .init(
            id: detail.id,
            parentId: detail.parentId,
            name: detail.name,
            slug: detail.slug,
            slugPath: detail.slugPath,
            assetCount: detail.assetCount,
            totalSizeBytes: detail.totalSizeBytes,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(_ item: Asset.Folder.List.Output.Item)
        -> MediaAdminAPI.Components.Schemas.MediaFolderQueryItemSchema
    {
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

    func mapAssetFolder(_ item: Asset.Folder.List.Output.Item)
        -> MediaAdminAPI.Components.Schemas.MediaAssetQueryItemFolderSchema
    {
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

    func map(_ detail: Variant.Detail.Output)
        -> MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema
    {
        .init(
            id: detail.id,
            key: detail.key,
            name: detail.name,
            isRequired: detail.isRequired,
            isActive: detail.isActive,
            processors: detail.processors.map(mapVariantProcessorListItem),
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(_ item: Variant.Search.Output.Item)
        -> MediaAdminAPI.Components.Schemas.MediaVariantQueryItemSchema
    {
        .init(
            id: item.id,
            key: item.key,
            name: item.name,
            isRequired: item.isRequired,
            isActive: item.isActive
        )
    }

    func map(_ item: Variant.Processor.Search.Output.Item)
        -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorQueryItemSchema
    {
        .init(
            id: item.id,
            name: item.name,
            matchExtensions: item.matchExtensions,
            commandTemplate: item.commandTemplate,
            isActive: item.isActive
        )
    }

    func mapVariantProcessorListItem(
        _ item: Variant.Processor.Search.Output.Item
    )
        -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema
    {
        .init(
            id: item.id,
            name: item.name,
            matchExtensions: item.matchExtensions,
            commandTemplate: item.commandTemplate,
            isActive: item.isActive
        )
    }

    func map(_ processor: Variant.Processor.Detail.Output)
        -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorDetailSchema
    {
        .init(
            id: processor.id,
            variantId: processor.variantId,
            name: processor.name,
            matchExtensions: processor.matchExtensions,
            commandTemplate: processor.commandTemplate,
            isActive: processor.isActive,
            createdAt: processor.createdAt.timeIntervalSince1970,
            updatedAt: processor.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ query: MediaAdminAPI.Components.Schemas
            .MediaVariantQueryItemSearchRequestQuerySchema
    ) -> Variant.Search.Input.Query {
        .init(page: map(query.page ?? .init()), search: query.filters.search)
    }

    func map(
        _ query: MediaAdminAPI.Components.Schemas
            .MediaVariantProcessorQueryItemSearchRequestQuerySchema
    ) -> Variant.Processor.Search.Input.Query {
        .init(page: map(query.page ?? .init()), search: query.filters.search)
    }
}
