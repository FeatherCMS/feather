public import BlogAppAPI
import BlogApplication
import BlogDomain
import BlogModule
import FeatherInfrastructure
import WebApplication

extension AppAPIGateway {
    public func blogSettingsGet(
        _ input: Operations.BlogSettingsGet.Input
    ) async throws -> Operations.BlogSettingsGet.Output {
        let settings = try await self.useCases.makeGetPublicSettings()
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
        let items = try await self.useCases.makeListPublicPosts()
            .execute(input: .init()).items
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
            let detail = try await self.useCases.makeGetPublicPost()
                .execute(input: .init(id: input.path.id))
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
        catch is Public.Post.Detail.UseCase.Error {
            return .notFound(
                .init(
                    body: .json(
                        notFoundErrorEnvelope(
                            message: "Blog post not found",
                            reason: "No published blog post matches this path."
                        )
                    )
                )
            )
        }
    }

    public func blogAuthorList(
        _ input: Operations.BlogAuthorList.Input
    ) async throws -> Operations.BlogAuthorList.Output {
        let items = try await self.useCases.makeListPublicAuthors()
            .execute(input: .init()).items
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
            let detail = try await self.useCases.makeGetPublicAuthor()
                .execute(input: .init(id: input.path.id))
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
        catch is Public.Author.Detail.UseCase.Error {
            return .notFound(
                .init(
                    body: .json(
                        notFoundErrorEnvelope(
                            message: "Blog author not found",
                            reason:
                                "No published blog author matches this path."
                        )
                    )
                )
            )
        }
    }

    public func blogTagList(
        _ input: Operations.BlogTagList.Input
    ) async throws -> Operations.BlogTagList.Output {
        let items = try await self.useCases.makeListPublicTags()
            .execute(input: .init()).items
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
            let detail = try await self.useCases.makeGetPublicTag()
                .execute(input: .init(id: input.path.id))
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
        catch is Public.Tag.Detail.UseCase.Error {
            return .notFound(
                .init(
                    body: .json(
                        notFoundErrorEnvelope(
                            message: "Blog tag not found",
                            reason: "No published blog tag matches this path."
                        )
                    )
                )
            )
        }
    }
}
