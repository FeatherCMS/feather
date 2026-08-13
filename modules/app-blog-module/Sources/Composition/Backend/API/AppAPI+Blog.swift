import BlogAppAPI
import BlogApplication
import BlogDomain
import FeatherInfrastructure
import WebApplication

extension BlogBackend {
    public func blogRouteSettings(
        _ input: Operations.BlogRouteSettings.Input
    ) async throws -> Operations.BlogRouteSettings.Output {
        let settings = try await self.makeGetPublicSettings()
            .run { context in
                try await context.settings.get()
            }

        return .ok(
            .init(
                body: .json(
                    .init(
                        postListPath: settings.postListPath,
                        authorListPath: settings.authorListPath,
                        tagListPath: settings.tagListPath,
                        postPathPrefix: settings.postPathPrefix,
                        authorPathPrefix: settings.authorPathPrefix,
                        tagPathPrefix: settings.tagPathPrefix,
                        siteNoIndex: false
                    )
                )
            )
        )
    }

    public func blogPostList(
        _ input: Operations.BlogPostList.Input
    ) async throws -> Operations.BlogPostList.Output {
        let items = try await self.makeListPublicPosts().execute()
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

    public func blogPostGet(
        _ input: Operations.BlogPostGet.Input
    ) async throws -> Operations.BlogPostGet.Output {
        do {
            let detail = try await self.makeGetPublicPost()
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
            var relatedPosts: [Components.Schemas.BlogPostSummarySchema] = []
            relatedPosts.reserveCapacity(detail.relatedPosts.count)
            for item in detail.relatedPosts {
                relatedPosts.append(await mapPublicPostSummary(item))
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
                            tags: tags,
                            relatedPosts: relatedPosts
                        )
                    )
                )
            )
        }
        catch is GetPublicPost.Error {
            return .notFound
        }
    }

    public func blogAuthorList(
        _ input: Operations.BlogAuthorList.Input
    ) async throws -> Operations.BlogAuthorList.Output {
        let items = try await self.makeListPublicAuthors().execute()
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

    public func blogAuthorGet(
        _ input: Operations.BlogAuthorGet.Input
    ) async throws -> Operations.BlogAuthorGet.Output {
        do {
            let detail = try await self.makeGetPublicAuthor()
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

    public func blogTagList(
        _ input: Operations.BlogTagList.Input
    ) async throws -> Operations.BlogTagList.Output {
        let items = try await self.makeListPublicTags().execute()
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

    public func blogTagGet(
        _ input: Operations.BlogTagGet.Input
    ) async throws -> Operations.BlogTagGet.Output {
        do {
            let detail = try await self.makeGetPublicTag()
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
