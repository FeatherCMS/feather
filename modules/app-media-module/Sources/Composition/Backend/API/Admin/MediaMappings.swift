import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import MediaAdminAPI
import MediaApplication

extension MediaBackend {
    func mapSortDirection(
        _ direction: MediaAdminAPI.Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }

    func map(
        _ page: MediaAdminAPI.Components.Schemas.SearchPageSchema
    ) -> Search.Page {
        .init(size: page.size, number: page.number)
    }

    func map(
        _ query: MediaAdminAPI.Components.Schemas
            .MediaAssetListItemSearchQuerySchema
    ) -> MediaAssetList.Query {
        let sort: [MediaAssetList.Query.Sort] = (query.sort ?? [])
            .map { rule in
                let field: MediaAssetList.Query.Sort.Field
                switch rule.field {
                case .id: field = .id
                case .storageKey: field = .storageKey
                case ._type: field = .type
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
            page: map(query.page),
            sort: sort,
            search: query.filters.search,
            parentId: (query.filters.parentId ?? "").emptyToNil
        )
    }

    func map(
        _ detail: MediaAssetDetail
    ) -> MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema {
        .init(
            id: detail.id,
            folderId: detail.folderId,
            storageKey: detail.storageKey,
            baseName: detail.baseName,
            _type: detail.type,
            sizeBytes: detail.sizeBytes,
            status: detail.status,
            title: detail.title,
            altText: detail.altText,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ item: MediaAssetList.Item
    ) -> MediaAdminAPI.Components.Schemas.MediaAssetListItemSchema {
        .init(
            id: item.id,
            folderId: item.folderId,
            storageKey: item.storageKey,
            baseName: item.baseName,
            _type: item.type,
            sizeBytes: item.sizeBytes,
            status: item.status,
            title: item.title,
            altText: item.altText,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ item: AssociatedVariantFile
    ) -> MediaAdminAPI.Components.Schemas.MediaAssetVariantListItemSchema {
        .init(
            variantId: item.variantId,
            name: item.name,
            _type: item.type,
            storageKey: item.storageKey
        )
    }

    func map(
        _ query: MediaAdminAPI.Components.Schemas
            .MediaFolderListItemSearchQuerySchema
    ) -> MediaFolderList.Query {
        .init(parentId: (query.filters.parentId ?? "").emptyToNil)
    }

    func map(
        _ detail: MediaFolderDetail
    ) -> MediaAdminAPI.Components.Schemas.MediaFolderDetailSchema {
        .init(
            id: detail.id,
            parentId: detail.parentId,
            name: detail.name,
            path: detail.path,
            assetCount: detail.assetCount,
            totalSizeBytes: detail.totalSizeBytes,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ item: MediaFolderList.Item
    ) -> MediaAdminAPI.Components.Schemas.MediaFolderListItemSchema {
        .init(
            id: item.id,
            parentId: item.parentId,
            name: item.name,
            path: item.path,
            assetCount: item.assetCount,
            totalSizeBytes: item.totalSizeBytes,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ query: MediaAdminAPI.Components.Schemas
            .MediaProcessorListItemSearchQuerySchema
    ) -> MediaProcessorList.Query {
        let sort: [MediaProcessorList.Query.Sort] = (query.sort ?? [])
            .map { rule in
                let field: MediaProcessorList.Query.Sort.Field
                switch rule.field {
                case .id: field = .id
                case .name: field = .name
                case .matchExtensions: field = .matchExtensions
                case .commandTemplate: field = .commandTemplate
                case .isRequired: field = .isRequired
                case .isActive: field = .isActive
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                return .init(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: MediaProcessorDetail
    ) -> MediaAdminAPI.Components.Schemas.MediaProcessorDetailSchema {
        .init(
            id: detail.id,
            name: detail.name,
            matchExtensions: detail.matchExtensions,
            commandTemplate: detail.commandTemplate,
            isRequired: detail.isRequired,
            isActive: detail.isActive,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ item: MediaProcessorList.Item
    ) -> MediaAdminAPI.Components.Schemas.MediaProcessorListItemSchema {
        .init(
            id: item.id,
            name: item.name,
            matchExtensions: item.matchExtensions,
            commandTemplate: item.commandTemplate,
            isRequired: item.isRequired,
            isActive: item.isActive
        )
    }
}
