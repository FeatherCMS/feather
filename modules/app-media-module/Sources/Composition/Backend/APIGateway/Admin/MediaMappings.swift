import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    func mapSortDirection(_ direction: MediaAdminAPI.Components.Schemas.SortDirection) -> Search.SortDirection { switch direction { case .asc: .asc; case .desc: .desc } }
    func map(_ page: MediaAdminAPI.Components.Schemas.SearchPageSchema) -> Search.Page { .init(size: page.size, number: page.number) }

    func map(_ query: MediaAdminAPI.Components.Schemas.MediaAssetNodeSearchItemSearchQuerySchema) -> MediaAssetList.Query {
        let sort = (query.sort ?? []).map { rule -> MediaAssetList.Query.Sort in
            let field: MediaAssetList.Query.Sort.Field
            switch rule.field { case .id: field = .id; case .name: field = .name; case .slugPath: field = .slugPath; case ._extension: field = .extension; case .sizeBytes: field = .sizeBytes; case .status: field = .status; case .title: field = .title; case .createdAt: field = .createdAt; case .updatedAt: field = .updatedAt }
            return .init(field: field, direction: mapSortDirection(rule.direction))
        }
        return .init(page: map(query.page), sort: sort, search: query.filters.search, parentId: (query.filters.parentId ?? "").emptyToNil)
    }

    func map(_ detail: MediaAssetDetail) -> MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema {
        .init(id: detail.id, folderId: detail.folderId, name: detail.name, slug: detail.slug, slugPath: detail.slugPath, url: detail.url, _extension: detail.extension, contentType: detail.contentType, sizeBytes: detail.sizeBytes, status: detail.status, title: detail.title, altText: detail.altText, createdAt: detail.createdAt.timeIntervalSince1970, updatedAt: detail.updatedAt.timeIntervalSince1970)
    }

    func map(_ item: MediaAssetResolve.Item) -> MediaAdminAPI.Components.Schemas.MediaAssetResolveItemSchema {
        .init(id: item.id, url: item.url, _extension: item.extension, title: item.title, altText: item.altText, variants: item.variants.map { .init(name: $0.name, url: $0.url, _extension: $0.extension) })
    }

    func map(_ item: MediaAssetList.Item) -> MediaAdminAPI.Components.Schemas.MediaAssetListItemSchema {
        .init(id: item.id, folderId: item.folderId, name: item.name, slug: item.slug, slugPath: item.slugPath, url: item.url, _extension: item.extension, contentType: item.contentType, sizeBytes: item.sizeBytes, status: item.status, title: item.title, altText: item.altText, createdAt: item.createdAt.timeIntervalSince1970, updatedAt: item.updatedAt.timeIntervalSince1970)
    }

    func map(_ item: MediaAssetSearchList.Item) -> MediaAdminAPI.Components.Schemas.MediaAssetNodeSearchItemSchema {
        switch item { case .asset(let item): return .init(kind: "file", file: map(item)); case .folder(let item): return .init(kind: "folder", folder: map(item)) }
    }

    func map(_ item: MediaBackend.UseCases.AssociatedVariantFile) -> MediaAdminAPI.Components.Schemas.MediaAssetVariantListItemSchema {
        .init(variantId: item.variantId, name: item.name, _extension: item.extension, url: mediaVariantPublicURL(assetId: item.assetId, name: item.name, extension: item.extension))
    }

    func map(_ query: MediaAdminAPI.Components.Schemas.MediaFolderListItemSearchQuerySchema) -> MediaFolderList.Query { .init(parentId: (query.filters.parentId ?? "").emptyToNil) }

    func map(_ detail: MediaFolderDetail) -> MediaAdminAPI.Components.Schemas.MediaFolderDetailSchema {
        .init(id: detail.id, parentId: detail.parentId, name: detail.name, slug: detail.slug, slugPath: detail.slugPath, assetCount: detail.assetCount, totalSizeBytes: detail.totalSizeBytes, createdAt: detail.createdAt.timeIntervalSince1970, updatedAt: detail.updatedAt.timeIntervalSince1970)
    }

    func map(_ item: MediaFolderList.Item) -> MediaAdminAPI.Components.Schemas.MediaFolderListItemSchema {
        .init(id: item.id, parentId: item.parentId, name: item.name, slug: item.slug, slugPath: item.slugPath, assetCount: item.assetCount, totalSizeBytes: item.totalSizeBytes, createdAt: item.createdAt.timeIntervalSince1970, updatedAt: item.updatedAt.timeIntervalSince1970)
    }

    func map(_ query: MediaAdminAPI.Components.Schemas.MediaProcessorListItemSearchQuerySchema) -> MediaProcessorList.Query {
        let sort = (query.sort ?? []).map { rule -> MediaProcessorList.Query.Sort in
            let field: MediaProcessorList.Query.Sort.Field
            switch rule.field { case .id: field = .id; case .name: field = .name; case .matchExtensions: field = .matchExtensions; case .commandTemplate: field = .commandTemplate; case .isRequired: field = .isRequired; case .isActive: field = .isActive; case .createdAt: field = .createdAt; case .updatedAt: field = .updatedAt }
            return .init(field: field, direction: mapSortDirection(rule.direction))
        }
        return .init(page: map(query.page), sort: sort, search: query.filters.search)
    }

    func map(_ detail: MediaProcessorDetail) -> MediaAdminAPI.Components.Schemas.MediaProcessorDetailSchema { .init(id: detail.id, name: detail.name, matchExtensions: detail.matchExtensions, commandTemplate: detail.commandTemplate, isRequired: detail.isRequired, isActive: detail.isActive, createdAt: detail.createdAt.timeIntervalSince1970, updatedAt: detail.updatedAt.timeIntervalSince1970) }
    func map(_ item: MediaProcessorList.Item) -> MediaAdminAPI.Components.Schemas.MediaProcessorListItemSchema { .init(id: item.id, name: item.name, matchExtensions: item.matchExtensions, commandTemplate: item.commandTemplate, isRequired: item.isRequired, isActive: item.isActive) }
}
