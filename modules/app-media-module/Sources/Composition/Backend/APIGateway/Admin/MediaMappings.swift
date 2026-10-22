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
        mapAssetFile(
            id: detail.id,
            folderId: detail.folderId,
            name: detail.name,
            slug: detail.slug,
            slugPath: detail.slugPath,
            url: detail.url,
            extension: detail.extension,
            contentType: detail.contentType,
            sizeBytes: detail.sizeBytes,
            status: detail.status,
            title: detail.title,
            altText: detail.altText,
            createdAt: detail.createdAt,
            updatedAt: detail.updatedAt
        )
    }

    func map(_ output: Asset.File.Add.Output)
        -> MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema
    {
        mapAssetFile(
            id: output.id,
            folderId: output.folderId,
            name: output.name,
            slug: output.slug,
            slugPath: output.slugPath,
            url: output.url,
            extension: output.extension,
            contentType: output.contentType,
            sizeBytes: output.sizeBytes,
            status: output.status,
            title: output.title,
            altText: output.altText,
            createdAt: output.createdAt,
            updatedAt: output.updatedAt
        )
    }

    func map(_ output: Asset.File.Edit.Output)
        -> MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema
    {
        mapAssetFile(
            id: output.id,
            folderId: output.folderId,
            name: output.name,
            slug: output.slug,
            slugPath: output.slugPath,
            url: output.url,
            extension: output.extension,
            contentType: output.contentType,
            sizeBytes: output.sizeBytes,
            status: output.status,
            title: output.title,
            altText: output.altText,
            createdAt: output.createdAt,
            updatedAt: output.updatedAt
        )
    }

    private func mapAssetFile(
        id: String,
        folderId: String?,
        name: String,
        slug: String,
        slugPath: String,
        url: String,
        extension fileExtension: String,
        contentType: String,
        sizeBytes: Int64,
        status: String,
        title: String?,
        altText: String?,
        createdAt: Date,
        updatedAt: Date
    ) -> MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema {
        .init(
            id: id,
            folderId: folderId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            url: mediaResolver.resolve(imagePath: url) ?? url,
            _extension: fileExtension,
            contentType: contentType,
            sizeBytes: sizeBytes,
            status: status,
            title: title,
            altText: altText,
            createdAt: createdAt.timeIntervalSince1970,
            updatedAt: updatedAt.timeIntervalSince1970
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
        mapMediaFolder(
            id: detail.id,
            parentId: detail.parentId,
            name: detail.name,
            slug: detail.slug,
            slugPath: detail.slugPath,
            assetCount: detail.assetCount,
            totalSizeBytes: detail.totalSizeBytes,
            createdAt: detail.createdAt,
            updatedAt: detail.updatedAt
        )
    }

    func map(_ output: Asset.Folder.Add.Output)
        -> MediaAdminAPI.Components.Schemas.MediaFolderDetailSchema
    {
        mapMediaFolder(
            id: output.id,
            parentId: output.parentId,
            name: output.name,
            slug: output.slug,
            slugPath: output.slugPath,
            assetCount: output.assetCount,
            totalSizeBytes: output.totalSizeBytes,
            createdAt: output.createdAt,
            updatedAt: output.updatedAt
        )
    }

    func map(_ output: Asset.Folder.Edit.Output)
        -> MediaAdminAPI.Components.Schemas.MediaFolderDetailSchema
    {
        mapMediaFolder(
            id: output.id,
            parentId: output.parentId,
            name: output.name,
            slug: output.slug,
            slugPath: output.slugPath,
            assetCount: output.assetCount,
            totalSizeBytes: output.totalSizeBytes,
            createdAt: output.createdAt,
            updatedAt: output.updatedAt
        )
    }

    private func mapMediaFolder(
        id: String,
        parentId: String?,
        name: String,
        slug: String,
        slugPath: String,
        assetCount: Int,
        totalSizeBytes: Int64,
        createdAt: Date,
        updatedAt: Date
    ) -> MediaAdminAPI.Components.Schemas.MediaFolderDetailSchema {
        .init(
            id: id,
            parentId: parentId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            assetCount: assetCount,
            totalSizeBytes: totalSizeBytes,
            createdAt: createdAt.timeIntervalSince1970,
            updatedAt: updatedAt.timeIntervalSince1970
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

    func mapAssetFolder(_ item: Asset.File.Search.Output.FolderItem)
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
        mapVariantDetail(
            id: detail.id,
            key: detail.key,
            name: detail.name,
            isRequired: detail.isRequired,
            isActive: detail.isActive,
            processors: detail.processors.map(mapVariantProcessorListItem),
            createdAt: detail.createdAt,
            updatedAt: detail.updatedAt
        )
    }

    func map(_ output: Variant.Add.Output)
        -> MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema
    {
        mapVariantDetail(
            id: output.id,
            key: output.key,
            name: output.name,
            isRequired: output.isRequired,
            isActive: output.isActive,
            processors: output.processors.map(mapVariantProcessorListItem),
            createdAt: output.createdAt,
            updatedAt: output.updatedAt
        )
    }

    func map(_ output: Variant.Edit.Output)
        -> MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema
    {
        mapVariantDetail(
            id: output.id,
            key: output.key,
            name: output.name,
            isRequired: output.isRequired,
            isActive: output.isActive,
            processors: output.processors.map(mapVariantProcessorListItem),
            createdAt: output.createdAt,
            updatedAt: output.updatedAt
        )
    }

    private func mapVariantDetail(
        id: String,
        key: String,
        name: String,
        isRequired: Bool,
        isActive: Bool,
        processors: [MediaAdminAPI.Components.Schemas
            .MediaVariantProcessorListItemSchema],
        createdAt: Date,
        updatedAt: Date
    ) -> MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema {
        .init(
            id: id,
            key: key,
            name: name,
            isRequired: isRequired,
            isActive: isActive,
            processors: processors,
            createdAt: createdAt.timeIntervalSince1970,
            updatedAt: updatedAt.timeIntervalSince1970
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
        mapVariantProcessorListItem(
            id: item.id,
            name: item.name,
            matchExtensions: item.matchExtensions,
            commandTemplate: item.commandTemplate,
            isActive: item.isActive
        )
    }

    func mapVariantProcessorListItem(
        _ item: Variant.Detail.Output.Processor
    )
        -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema
    {
        mapVariantProcessorListItem(
            id: item.id,
            name: item.name,
            matchExtensions: item.matchExtensions,
            commandTemplate: item.commandTemplate,
            isActive: item.isActive
        )
    }

    func mapVariantProcessorListItem(
        _ item: Variant.Add.Output.Processor
    )
        -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema
    {
        mapVariantProcessorListItem(
            id: item.id,
            name: item.name,
            matchExtensions: item.matchExtensions,
            commandTemplate: item.commandTemplate,
            isActive: item.isActive
        )
    }

    func mapVariantProcessorListItem(
        _ item: Variant.Edit.Output.Processor
    )
        -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema
    {
        mapVariantProcessorListItem(
            id: item.id,
            name: item.name,
            matchExtensions: item.matchExtensions,
            commandTemplate: item.commandTemplate,
            isActive: item.isActive
        )
    }

    private func mapVariantProcessorListItem(
        id: String,
        name: String,
        matchExtensions: String,
        commandTemplate: String,
        isActive: Bool
    ) -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema {
        .init(
            id: id,
            name: name,
            matchExtensions: matchExtensions,
            commandTemplate: commandTemplate,
            isActive: isActive
        )
    }

    func map(_ processor: Variant.Processor.Detail.Output)
        -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorDetailSchema
    {
        mapVariantProcessorDetail(
            id: processor.id,
            variantId: processor.variantId,
            name: processor.name,
            matchExtensions: processor.matchExtensions,
            commandTemplate: processor.commandTemplate,
            isActive: processor.isActive,
            createdAt: processor.createdAt,
            updatedAt: processor.updatedAt
        )
    }

    func map(_ processor: Variant.Processor.Add.Output)
        -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorDetailSchema
    {
        mapVariantProcessorDetail(
            id: processor.id,
            variantId: processor.variantId,
            name: processor.name,
            matchExtensions: processor.matchExtensions,
            commandTemplate: processor.commandTemplate,
            isActive: processor.isActive,
            createdAt: processor.createdAt,
            updatedAt: processor.updatedAt
        )
    }

    func map(_ processor: Variant.Processor.Edit.Output)
        -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorDetailSchema
    {
        mapVariantProcessorDetail(
            id: processor.id,
            variantId: processor.variantId,
            name: processor.name,
            matchExtensions: processor.matchExtensions,
            commandTemplate: processor.commandTemplate,
            isActive: processor.isActive,
            createdAt: processor.createdAt,
            updatedAt: processor.updatedAt
        )
    }

    private func mapVariantProcessorDetail(
        id: String,
        variantId: String,
        name: String,
        matchExtensions: String,
        commandTemplate: String,
        isActive: Bool,
        createdAt: Date,
        updatedAt: Date
    ) -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorDetailSchema {
        .init(
            id: id,
            variantId: variantId,
            name: name,
            matchExtensions: matchExtensions,
            commandTemplate: commandTemplate,
            isActive: isActive,
            createdAt: createdAt.timeIntervalSince1970,
            updatedAt: updatedAt.timeIntervalSince1970
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
