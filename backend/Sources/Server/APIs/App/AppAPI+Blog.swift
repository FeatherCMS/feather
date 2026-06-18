import BlogApplication
import Infrastructure
import AppOpenAPI
import WebApplication

extension AppAPI {
    func blogPostList(
        _ input: Operations.BlogPostList.Input
    ) async throws -> Operations.BlogPostList.Output {
        let items = try await modules.blog.makeListPublicPosts().execute()
        var result: [Components.Schemas.BlogPostSummarySchema] = []
        result.reserveCapacity(items.count)
        for item in items {
            result.append(await mapPublicPostSummary(item))
        }
        return .ok(
            .init(
                body: .json(
                    result
                )
            )
        )
    }

    func blogPostGet(
        _ input: Operations.BlogPostGet.Input
    ) async throws -> Operations.BlogPostGet.Output {
        do {
            let detail = try await modules.blog.makeGetPublicPost()
                .execute(
                    id: input.path.id
                )
            let media = await publicMedia(assetId: detail.imageAssetId)
            var authors: [Components.Schemas.BlogAuthorSummarySchema] = []
            authors.reserveCapacity(detail.authors.count)
            for item in detail.authors {
                authors.append(await mapPublicAuthorSummary(item))
            }
            var tags: [Components.Schemas.BlogTagSummarySchema] = []
            tags.reserveCapacity(detail.tags.count)
            for item in detail.tags {
                tags.append(await mapPublicTagSummary(item))
            }
            return .ok(
                .init(
                    body: .json(
                        .init(
                            id: detail.id,
                            excerpt: detail.excerpt,
                            content: detail.content,
                            imageURL: media?.defaultURL ?? detail.imageURL,
                            media: mapPublicMedia(media),
                            metadata: mapPublicMetadata(
                                detail.metadata,
                                title: detail.title,
                                excerpt: detail.excerpt,
                                imageURL: media?.defaultURL ?? detail.imageURL
                            ),
                            authors: authors,
                            tags: tags
                        )
                    )
                )
            )
        }
        catch is GetPublicPost.Error {
            return .notFound
        }
    }

    func blogAuthorList(
        _ input: Operations.BlogAuthorList.Input
    ) async throws -> Operations.BlogAuthorList.Output {
        let items = try await modules.blog.makeListPublicAuthors().execute()
        var result: [Components.Schemas.BlogAuthorSummarySchema] = []
        result.reserveCapacity(items.count)
        for item in items {
            result.append(await mapPublicAuthorSummary(item))
        }
        return .ok(
            .init(
                body: .json(
                    result
                )
            )
        )
    }

    func blogAuthorGet(
        _ input: Operations.BlogAuthorGet.Input
    ) async throws -> Operations.BlogAuthorGet.Output {
        do {
            let detail = try await modules.blog.makeGetPublicAuthor()
                .execute(
                    id: input.path.id
                )
            let media = await publicMedia(assetId: detail.imageAssetId)
            var posts: [Components.Schemas.BlogPostSummarySchema] = []
            posts.reserveCapacity(detail.posts.count)
            for item in detail.posts {
                posts.append(await mapPublicPostSummary(item))
            }
            return .ok(
                .init(
                    body: .json(
                        .init(
                            id: detail.id,
                            name: detail.name,
                            excerpt: detail.excerpt,
                            content: detail.content,
                            imageURL: media?.defaultURL ?? detail.imageURL,
                            media: mapPublicMedia(media),
                            metadata: mapPublicMetadata(
                                detail.metadata,
                                title: detail.name,
                                excerpt: detail.excerpt,
                                imageURL: media?.defaultURL ?? detail.imageURL
                            ),
                            links: detail.links.map(mapPublicAuthorLink),
                            posts: posts
                        )
                    )
                )
            )
        }
        catch is GetPublicAuthor.Error {
            return .notFound
        }
    }

    func blogTagList(
        _ input: Operations.BlogTagList.Input
    ) async throws -> Operations.BlogTagList.Output {
        let items = try await modules.blog.makeListPublicTags().execute()
        var result: [Components.Schemas.BlogTagSummarySchema] = []
        result.reserveCapacity(items.count)
        for item in items {
            result.append(await mapPublicTagSummary(item))
        }
        return .ok(
            .init(
                body: .json(
                    result
                )
            )
        )
    }

    func blogTagGet(
        _ input: Operations.BlogTagGet.Input
    ) async throws -> Operations.BlogTagGet.Output {
        do {
            let detail = try await modules.blog.makeGetPublicTag()
                .execute(
                    id: input.path.id
                )
            let media = await publicMedia(assetId: detail.imageAssetId)
            var posts: [Components.Schemas.BlogPostSummarySchema] = []
            posts.reserveCapacity(detail.posts.count)
            for item in detail.posts {
                posts.append(await mapPublicPostSummary(item))
            }
            return .ok(
                .init(
                    body: .json(
                        .init(
                            id: detail.id,
                            excerpt: detail.excerpt,
                            content: detail.content,
                            imageURL: media?.defaultURL ?? detail.imageURL,
                            media: mapPublicMedia(media),
                            metadata: mapPublicMetadata(
                                detail.metadata,
                                title: detail.title,
                                excerpt: detail.excerpt,
                                imageURL: media?.defaultURL ?? detail.imageURL
                            ),
                            posts: posts
                        )
                    )
                )
            )
        }
        catch is GetPublicTag.Error {
            return .notFound
        }
    }
}
