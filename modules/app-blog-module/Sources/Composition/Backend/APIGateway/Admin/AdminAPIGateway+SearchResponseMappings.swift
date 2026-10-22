import BlogAdminAPI
import FeatherApplication

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

    func responseQuery(
        from query: BlogAdminAPI.Components.Schemas
            .BlogAuthorLinkQueryItemSearchRequestQuerySchema
    )
        -> BlogAdminAPI.Components.Schemas
        .BlogAuthorLinkQueryItemSearchResponseQuerySchema
    {
        let page = map(query.page)
        let sort = query.sort?
            .map { item in
                let field:
                    BlogAdminAPI.Components.Schemas
                        .BlogAuthorLinkQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch item.field {
                case .id: field = .id
                case .label: field = .label
                case .priority: field = .priority
                case .url: field = .url
                case .permission: field = .permission
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                return BlogAdminAPI.Components.Schemas
                    .BlogAuthorLinkQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: item.direction)
            }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(search: query.filters.search)
        )
    }

    func responseQuery(
        from query: BlogAdminAPI.Components.Schemas
            .BlogPostQueryItemSearchRequestQuerySchema
    )
        -> BlogAdminAPI.Components.Schemas
        .BlogPostQueryItemSearchResponseQuerySchema
    {
        let page = map(query.page)
        let sort = query.sort?
            .map { item in
                let field:
                    BlogAdminAPI.Components.Schemas
                        .BlogPostQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch item.field {
                case .id: field = .id
                case .title: field = .title
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                return BlogAdminAPI.Components.Schemas
                    .BlogPostQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: item.direction)
            }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(search: query.filters.search)
        )
    }

    func responseQuery(
        from query: BlogAdminAPI.Components.Schemas
            .BlogTagQueryItemSearchRequestQuerySchema
    )
        -> BlogAdminAPI.Components.Schemas
        .BlogTagQueryItemSearchResponseQuerySchema
    {
        let page = map(query.page)
        let sort = query.sort?
            .map { item in
                let field:
                    BlogAdminAPI.Components.Schemas
                        .BlogTagQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch item.field {
                case .id: field = .id
                case .title: field = .title
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                return BlogAdminAPI.Components.Schemas
                    .BlogTagQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: item.direction)
            }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(search: query.filters.search)
        )
    }
}
