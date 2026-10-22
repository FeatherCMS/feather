import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherApplication

extension AdminAPIGateway {
    func responseQuery(
        from query: BlogAdminAPI.Components.Schemas
            .AuthorLinkQueryItemSearchRequestQuerySchema
    )
        -> BlogAdminAPI.Components.Schemas
        .AuthorLinkQueryItemSearchResponseQuerySchema
    {
        let page = map(query.page)
        let sort = query.sort?
            .map { item in
                let field:
                    BlogAdminAPI.Components.Schemas
                        .AuthorLinkQueryItemSearchResponseQuerySchema
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
                    .AuthorLinkQueryItemSearchResponseQuerySchema
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
            .AuthorLinkQueryItemSearchRequestQuerySchema
    ) -> AuthorLink.Search.Input.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: AuthorLink.Search.Input.Query.Sort.Field
                switch item.field {
                case .id:
                    field = .id
                case .label:
                    field = .label
                case .url:
                    field = .url
                case .priority:
                    field = .priority
                case .permission:
                    field = .permission
                case .createdAt:
                    field = .createdAt
                case .updatedAt:
                    field = .updatedAt
                }
                return AuthorLink.Search.Input.Query.Sort(
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
        _ detail: AuthorLink.Detail.Output
    ) -> BlogAdminAPI.Components.Schemas.AuthorLinkGetSchema {
        .init(
            id: detail.id,
            menuId: detail.authorId,
            label: detail.label,
            url: detail.url,
            priority: detail.priority,
            isBlank: detail.isBlank,
            permission: detail.permission,
            notes: detail.notes,
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ output: AuthorLink.Add.Output
    ) -> BlogAdminAPI.Components.Schemas.AuthorLinkGetSchema {
        map(
            AuthorLink.Detail.Output(
                id: output.id,
                authorId: output.authorId,
                label: output.label,
                url: output.url,
                priority: output.priority,
                isBlank: output.isBlank,
                permission: output.permission,
                notes: output.notes,
                createdAt: output.createdAt,
                updatedAt: output.updatedAt
            )
        )
    }

    func map(
        _ output: AuthorLink.Edit.Output
    ) -> BlogAdminAPI.Components.Schemas.AuthorLinkGetSchema {
        map(
            AuthorLink.Detail.Output(
                id: output.id,
                authorId: output.authorId,
                label: output.label,
                url: output.url,
                priority: output.priority,
                isBlank: output.isBlank,
                permission: output.permission,
                notes: output.notes,
                createdAt: output.createdAt,
                updatedAt: output.updatedAt
            )
        )
    }

    func map(
        _ item: AuthorLink.List.Output.Item
    ) -> BlogAdminAPI.Components.Schemas.AuthorLinkListItemSchema {
        .init(
            id: item.id,
            menuId: item.authorId,
            label: item.label,
            url: item.url,
            priority: item.priority,
            isBlank: item.isBlank,
            permission: item.permission,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }

    func mapQuery(
        _ item: AuthorLink.Search.Output.Item
    ) -> BlogAdminAPI.Components.Schemas.AuthorLinkQueryItemSchema {
        .init(
            id: item.id,
            menuId: item.authorId,
            label: item.label,
            url: item.url,
            priority: item.priority,
            isBlank: item.isBlank,
            permission: item.permission,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }
}
