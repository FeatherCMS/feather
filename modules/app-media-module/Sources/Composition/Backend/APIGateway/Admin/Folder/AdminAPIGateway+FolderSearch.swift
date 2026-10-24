import FeatherApplication
import FeatherModuleKit
import Foundation
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    public func mediaFolderQuery(
        _ input: Operations.MediaFolderQuery.Input
    ) async throws -> Operations.MediaFolderQuery.Output {
        let query:
            Components.Schemas.MediaFolderQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeSearchFolders()
            .execute(
                subject: subject,
                input: .init(query: mapFolderSearchQuery(query))
            )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: folderSearchResponseQuery(from: query),
                        data: .init(
                            items: result.items.map(mapFolderSearchItem),
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    private func mapFolderSearchQuery(
        _ query: Components.Schemas.MediaFolderQueryItemSearchRequestQuerySchema
    ) -> Asset.Folder.Search.Input.Query {
        let page = query.page ?? .init()
        return .init(
            page: .init(size: page.size ?? 20, number: page.number ?? 1),
            sort: (query.sort ?? []).map { rule in
                let field: Asset.Folder.Search.Input.Query.Sort.Field
                switch rule.field {
                case .id: field = .id
                case .name: field = .name
                case .path: field = .path
                case .assetCount: field = .assetCount
                case .totalSizeBytes: field = .totalSizeBytes
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
            parentId: (query.filters.parentId ?? "").emptyToNil
        )
    }

    private func folderSearchResponseQuery(
        from query: Components.Schemas.MediaFolderQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas.MediaFolderQueryItemSearchResponseQuerySchema {
        let page = query.page ?? .init()
        let sort = query.sort?.map { rule
            -> Components.Schemas.MediaFolderQueryItemSearchResponseQuerySchema.SortPayloadPayload in
            let field: Components.Schemas
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
            return .init(field: field, direction: rule.direction)
        }
        return .init(
            page: .init(size: page.size ?? 20, number: page.number ?? 1),
            sort: sort,
            filters: .init(parentId: query.filters.parentId)
        )
    }

    private func mapFolderSearchItem(
        _ item: Asset.Folder.Search.Output.Item
    ) -> Components.Schemas.MediaFolderQueryItemSchema {
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
