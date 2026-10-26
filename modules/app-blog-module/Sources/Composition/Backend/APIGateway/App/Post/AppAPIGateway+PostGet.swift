public import BlogAppAPI
import BlogApplication
import Foundation
import WebApplication
import WebDomain
import WebModule

extension AppAPIGateway {
    public func blogPostGet(
        _ input: Operations.BlogPostGet.Input
    ) async throws -> Operations.BlogPostGet.Output {
        do {
            let detail = try await self.useCases.makeDetailPublicPost()
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
                            media: media.map {
                                .init(
                                    assetId: $0.assetId,
                                    originalURL: $0.originalURL,
                                    defaultURL: $0.defaultURL,
                                    variants: $0.variants.map {
                                        .init(key: $0.key, url: $0.url)
                                    }
                                )
                            },
                            metadata: mapPublicPostMetadata(
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
        catch is BlogApplication.Public.Post.Detail.Error {
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

    private func mapPublicPostMetadata(
        _ metadata: WebModule.Metadata.Snapshot,
        title: String,
        excerpt: String,
        imageURL: String
    ) -> Components.Schemas.WebMetadataContentSchema {
        let resolved = WebModule.Metadata.Snapshot.Resolved(
            metadata: metadata,
            fallbackTitle: title,
            fallbackExcerpt: excerpt,
            fallbackImageURL: imageURL
        )
        let template: String
        if metadata.template != "default" {
            template = metadata.template
        }
        else {
            switch metadata.referenceType {
            case "blog.post": template = "blog.post"
            case "blog.author": template = "blog.author"
            case "blog.tag": template = "blog.tag"
            default: template = metadata.template
            }
        }
        return .init(
            slug: metadata.slug,
            template: template,
            publicationDate: metadata.publicationDate.timeIntervalSince1970,
            expirationDate: metadata.expirationDate?.timeIntervalSince1970,
            status: metadata.status.rawValue,
            title: resolved.title,
            excerpt: resolved.excerpt,
            imageURL: resolved.imageURL ?? "",
            canonicalURL: metadata.canonicalURL,
            noIndex: metadata.noIndex,
            cssCodeInjection: metadata.cssCodeInjection,
            javascriptCodeInjection: metadata.javascriptCodeInjection,
            structuredDataCodeInjection: metadata.structuredDataCodeInjection
        )
    }
}
