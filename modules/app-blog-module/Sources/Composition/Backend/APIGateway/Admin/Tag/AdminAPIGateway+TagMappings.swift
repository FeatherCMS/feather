import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherApplication

extension AdminAPIGateway {
    func responseQuery(
        from query: BlogAdminAPI.Components.Schemas
            .TagQueryItemSearchRequestQuerySchema
    )
        -> BlogAdminAPI.Components.Schemas
        .TagQueryItemSearchResponseQuerySchema
    {
        let page = map(query.page)
        let sort = query.sort?
            .map { item in
                let field:
                    BlogAdminAPI.Components.Schemas
                        .TagQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch item.field {
                case .id: field = .id
                case .title: field = .title
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                return BlogAdminAPI.Components.Schemas
                    .TagQueryItemSearchResponseQuerySchema
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
            .TagQueryItemSearchRequestQuerySchema
    ) -> Tag.Search.Input.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: Tag.Search.Input.Query.Sort.Field
                switch item.field {
                case .id:
                    field = .id
                case .title:
                    field = .title
                case .createdAt:
                    field = .createdAt
                case .updatedAt:
                    field = .updatedAt
                }
                return Tag.Search.Input.Query.Sort(
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
        _ detail: Tag.Detail.Output
    ) -> BlogAdminAPI.Components.Schemas.TagGetSchema {
        .init(
            id: detail.id,
            title: detail.title,
            excerpt: detail.excerpt,
            content: detail.content,
            imageAssetId: detail.imageAssetId,
            metadata: map(detail.metadata),
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ output: Tag.Add.Output
    ) -> BlogAdminAPI.Components.Schemas.TagGetSchema {
        map(
            Tag.Detail.Output(
                id: output.id,
                title: output.title,
                excerpt: output.excerpt,
                content: output.content,
                imageAssetId: output.imageAssetId,
                metadata: output.metadata,
                createdAt: output.createdAt,
                updatedAt: output.updatedAt
            )
        )
    }

    func map(
        _ output: Tag.Edit.Output
    ) -> BlogAdminAPI.Components.Schemas.TagGetSchema {
        map(
            Tag.Detail.Output(
                id: output.id,
                title: output.title,
                excerpt: output.excerpt,
                content: output.content,
                imageAssetId: output.imageAssetId,
                metadata: output.metadata,
                createdAt: output.createdAt,
                updatedAt: output.updatedAt
            )
        )
    }

    func map(
        _ item: Tag.List.Output.Item
    ) -> BlogAdminAPI.Components.Schemas.TagListItemSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageAssetId: item.imageAssetId,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }

    func mapQuery(
        _ item: Tag.Search.Output.Item
    ) -> BlogAdminAPI.Components.Schemas.TagQueryItemSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageAssetId: item.imageAssetId,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
        )
    }
}
