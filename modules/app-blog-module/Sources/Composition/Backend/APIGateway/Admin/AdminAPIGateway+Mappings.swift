import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherApplication
import FeatherModuleKit
import Foundation
import WebAdminAPI
import WebApplication
import WebDomain

extension AdminAPIGateway {
    func timestamp(
        _ date: Date
    ) -> Double {
        date.timeIntervalSince1970
    }

    func timestamp(
        _ date: Date?
    ) -> Double? {
        date.map(timestamp)
    }

    func mapSortDirection(
        _ direction: BlogAdminAPI.Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc:
            .asc
        case .desc:
            .desc
        }
    }

    func map(
        _ page: BlogAdminAPI.Components.Schemas.SearchPageSchema?
    ) -> Search.Page {
        let defaults = Search.Page()
        return
            Search.Page(
                size: page?.size ?? defaults.size,
                number: page?.number ?? defaults.number
            )
            .normalized()
    }

    func mapMetadataStatus(
        _ value: String?
    ) -> Metadata.Model.Status {
        value.flatMap(Metadata.Model.Status.init(rawValue:)) ?? .draft
    }

    func mapBlogMetadata(
        _ metadata: WebAdminAPI.Components.Schemas.WebMetadataCreateSchema
    ) -> PageMetadataInput {
        .init(
            slug: metadata.slug,
            publicationDate: metadata.publicationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            expirationDate: metadata.expirationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            status: mapMetadataStatus(metadata.status),
            title: metadata.title,
            excerpt: metadata.excerpt,
            imageURL: metadata.imageUrl,
            canonicalURL: metadata.canonicalUrl,
            noIndex: metadata.noIndex ?? false,
            primaryKeyword: metadata.primaryKeyword ?? "",
            cssCodeInjection: metadata.cssCodeInjection,
            javascriptCodeInjection: metadata.javascriptCodeInjection,
            structuredDataCodeInjection: metadata.structuredDataCodeInjection
        )
    }

    func defaultBlogMetadata(
        title: String,
        excerpt: String
    ) -> PageMetadataInput {
        .init(
            slug: title.slugified,
            publicationDate: nil,
            expirationDate: nil,
            status: .draft,
            title: title,
            excerpt: excerpt,
            imageURL: nil,
            canonicalURL: "",
            noIndex: false,
            primaryKeyword: "",
            cssCodeInjection: "",
            javascriptCodeInjection: "",
            structuredDataCodeInjection: ""
        )
    }

    func mergeBlogMetadata(
        _ patch: WebAdminAPI.Components.Schemas.WebMetadataPatchSchema,
        into detail: WebAdminAPI.Components.Schemas.WebMetadataDetailSchema
    ) -> PageMetadataInput {
        let publicationDate = (patch.publicationDate ?? detail.publicationDate)
            .map(Date.init(timeIntervalSince1970:))
        let expirationDate = (patch.expirationDate ?? detail.expirationDate)
            .map(Date.init(timeIntervalSince1970:))
        let status = mapMetadataStatus(patch.status)
        let title = patch.title ?? detail.title
        let excerpt = patch.excerpt ?? detail.excerpt
        let imageURL = patch.imageUrl ?? detail.imageUrl
        let canonicalURL = patch.canonicalUrl ?? detail.canonicalUrl
        let noIndex = patch.noIndex ?? detail.noIndex
        let primaryKeyword = patch.primaryKeyword ?? detail.primaryKeyword
        let cssCodeInjection =
            patch.cssCodeInjection
            ?? detail.cssCodeInjection
        let javascriptCodeInjection =
            patch.javascriptCodeInjection
            ?? detail.javascriptCodeInjection
        let structuredDataCodeInjection =
            patch.structuredDataCodeInjection
            ?? detail.structuredDataCodeInjection
        return .init(
            slug: patch.slug ?? detail.slug,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: status,
            title: title,
            excerpt: excerpt,
            imageURL: imageURL,
            canonicalURL: canonicalURL,
            noIndex: noIndex,
            primaryKeyword: primaryKeyword,
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection
        )
    }

    func map(
        _ detail: MetadataDetail
    ) -> BlogAdminAPI.Components.Schemas.WebMetadataDetailSchema {
        .init(
            id: detail.id,
            referenceType: detail.referenceType,
            referenceId: detail.referenceID,
            slug: detail.slug,
            template: detail.template,
            publicationDate: timestamp(detail.publicationDate),
            expirationDate: timestamp(detail.expirationDate),
            status: detail.status.rawValue,
            title: detail.title,
            excerpt: detail.excerpt,
            imageUrl: detail.imageURL,
            canonicalUrl: detail.canonicalURL,
            noIndex: detail.noIndex,
            primaryKeyword: detail.primaryKeyword ?? "",
            cssCodeInjection: detail.cssCodeInjection,
            javascriptCodeInjection: detail.javascriptCodeInjection,
            structuredDataCodeInjection: detail.structuredDataCodeInjection,
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
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

    func map(
        _ query: BlogAdminAPI.Components.Schemas
            .BlogTagQueryItemSearchRequestQuerySchema
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
    ) -> BlogAdminAPI.Components.Schemas.BlogTagDetailSchema {
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
    ) -> BlogAdminAPI.Components.Schemas.BlogTagDetailSchema {
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
    ) -> BlogAdminAPI.Components.Schemas.BlogTagDetailSchema {
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
    ) -> BlogAdminAPI.Components.Schemas.BlogTagListItemSchema {
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
    ) -> BlogAdminAPI.Components.Schemas.BlogTagQueryItemSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageAssetId: item.imageAssetId,
            createdAt: timestamp(item.createdAt),
            updatedAt: timestamp(item.updatedAt)
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
                case .key, .name:
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

    func map(
        _ query: BlogAdminAPI.Components.Schemas
            .BlogAuthorLinkQueryItemSearchRequestQuerySchema
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
    ) -> BlogAdminAPI.Components.Schemas.BlogAuthorLinkDetailSchema {
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
    ) -> BlogAdminAPI.Components.Schemas.BlogAuthorLinkDetailSchema {
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
    ) -> BlogAdminAPI.Components.Schemas.BlogAuthorLinkDetailSchema {
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
    ) -> BlogAdminAPI.Components.Schemas.BlogAuthorLinkListItemSchema {
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
    ) -> BlogAdminAPI.Components.Schemas.BlogAuthorLinkQueryItemSchema {
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
