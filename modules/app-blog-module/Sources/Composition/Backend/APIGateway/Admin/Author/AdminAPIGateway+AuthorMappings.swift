import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherApplication
import Foundation

extension AdminAPIGateway {
    func responseQuery(
        from query: BlogAdminAPI.Components.Schemas
            .BlogAuthorQueryItemSearchRequestQuerySchema
    )
        -> BlogAdminAPI.Components.Schemas
        .BlogAuthorQueryItemSearchResponseQuerySchema
    {
        let page = map(query.page)
        let sort = query.sort?
            .map { item in
                let field:
                    BlogAdminAPI.Components.Schemas
                        .BlogAuthorQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch item.field {
                case .id: field = .id
                case .key: field = .key
                case .name: field = .name
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                return BlogAdminAPI.Components.Schemas
                    .BlogAuthorQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: item.direction)
            }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(search: query.filters.search)
        )
    }

    func map(
        _ query: BlogAdminAPI.Components.Schemas
            .BlogAuthorQueryItemSearchRequestQuerySchema
    ) -> Author.Search.Input.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: Author.Search.Input.Query.Sort.Field
                switch item.field {
                case .id:
                    field = .id
                case .key:
                    field = .key
                case .name:
                    field = .name
                case .createdAt:
                    field = .createdAt
                case .updatedAt:
                    field = .updatedAt
                }
                return Author.Search.Input.Query.Sort(
                    field: field,
                    direction: mapSortDirection(item.direction)
                )
            }
        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: Author.Detail.Output
    ) -> BlogAdminAPI.Components.Schemas.BlogAuthorDetailSchema {
        .init(
            id: detail.id,
            name: detail.name,
            excerpt: detail.excerpt,
            content: detail.content,
            profileImageAssetId: detail.profileImageAssetId,
            metadata: map(detail.metadata),
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ detail: Author.Add.Output
    ) -> BlogAdminAPI.Components.Schemas.BlogAuthorDetailSchema {
        .init(
            id: detail.id,
            name: detail.name,
            excerpt: detail.excerpt,
            content: detail.content,
            profileImageAssetId: detail.profileImageAssetId,
            metadata: map(detail.metadata),
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ detail: Author.Edit.Output
    ) -> BlogAdminAPI.Components.Schemas.BlogAuthorDetailSchema {
        .init(
            id: detail.id,
            name: detail.name,
            excerpt: detail.excerpt,
            content: detail.content,
            profileImageAssetId: detail.profileImageAssetId,
            metadata: map(detail.metadata),
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ item: Author.Search.Output.Item
    ) -> BlogAdminAPI.Components.Schemas.BlogAuthorQueryItemSchema {
        .init(
            id: item.id,
            name: item.name,
            excerpt: item.excerpt,
            profileImageAssetId: item.profileImageAssetId,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }

    func map(
        _ item: Author.List.Output.Item
    ) -> BlogAdminAPI.Components.Schemas.BlogAuthorListItemSchema {
        .init(
            id: item.id,
            name: item.name,
            excerpt: item.excerpt,
            profileImageAssetId: item.profileImageAssetId,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }
}
