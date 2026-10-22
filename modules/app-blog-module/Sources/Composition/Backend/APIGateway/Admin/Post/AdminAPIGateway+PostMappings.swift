import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherApplication
import Foundation

extension AdminAPIGateway {
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

    func map(
        _ query: BlogAdminAPI.Components.Schemas
            .BlogPostQueryItemSearchRequestQuerySchema
    ) -> Post.Search.Input.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: Post.Search.Input.Query.Sort.Field
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
                return Post.Search.Input.Query.Sort(
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
        _ detail: Post.Detail.Output
    ) -> BlogAdminAPI.Components.Schemas.BlogPostDetailSchema {
        .init(
            id: detail.id,
            title: detail.title,
            excerpt: detail.excerpt,
            content: detail.content,
            imageAssetId: detail.imageAssetId,
            authorIds: detail.authorIds,
            tagIds: detail.tagIds,
            metadata: map(detail.metadata),
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }

    func map(
        _ output: Post.Add.Output
    ) -> BlogAdminAPI.Components.Schemas.BlogPostDetailSchema {
        map(
            Post.Detail.Output(
                id: output.id,
                title: output.title,
                excerpt: output.excerpt,
                content: output.content,
                imageAssetId: output.imageAssetId,
                authorIds: output.authorIds,
                tagIds: output.tagIds,
                metadata: output.metadata,
                createdAt: output.createdAt,
                updatedAt: output.updatedAt
            )
        )
    }

    func map(
        _ output: Post.Edit.Output
    ) -> BlogAdminAPI.Components.Schemas.BlogPostDetailSchema {
        map(
            Post.Detail.Output(
                id: output.id,
                title: output.title,
                excerpt: output.excerpt,
                content: output.content,
                imageAssetId: output.imageAssetId,
                authorIds: output.authorIds,
                tagIds: output.tagIds,
                metadata: output.metadata,
                createdAt: output.createdAt,
                updatedAt: output.updatedAt
            )
        )
    }

    func map(
        _ item: Post.List.Output.Item
    ) -> BlogAdminAPI.Components.Schemas.BlogPostListItemSchema {
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
        _ item: Post.Search.Output.Item
    ) -> BlogAdminAPI.Components.Schemas.BlogPostQueryItemSchema {
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
