public import BlogAppAPI
import BlogApplication
import Foundation
import WebApplication
import WebDomain
import WebModule

extension AppAPIGateway {
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

    func mapPublicAuthorSummary(
        _ summary: BlogApplication.Public.Author.Summary.Item
    ) async -> Components.Schemas.BlogAuthorSummarySchema {
        let media = await publicMedia(assetId: summary.imageAssetId)
        let resolvedMetadata = WebModule.Metadata.Snapshot.Resolved(
            metadata: summary.metadata,
            fallbackTitle: summary.name,
            fallbackExcerpt: summary.excerpt,
            fallbackImageURL: media?.defaultURL ?? summary.imageURL
        )
        let template: String
        if summary.metadata.template != "default" {
            template = summary.metadata.template
        }
        else {
            switch summary.metadata.referenceType {
            case "blog.post": template = "blog.post"
            case "blog.author": template = "blog.author"
            case "blog.tag": template = "blog.tag"
            default: template = summary.metadata.template
            }
        }
        return .init(
            id: summary.id,
            name: summary.name,
            excerpt: summary.excerpt,
            content: summary.content,
            imageURL: media?.defaultURL ?? summary.imageURL,
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
            metadata: .init(
                slug: summary.metadata.slug,
                template: template,
                publicationDate: summary.metadata.publicationDate.timeIntervalSince1970,
                expirationDate: summary.metadata.expirationDate?.timeIntervalSince1970,
                status: summary.metadata.status.rawValue,
                title: resolvedMetadata.title,
                excerpt: resolvedMetadata.excerpt,
                imageURL: resolvedMetadata.imageURL ?? "",
                canonicalURL: summary.metadata.canonicalURL,
                noIndex: summary.metadata.noIndex,
                cssCodeInjection: summary.metadata.cssCodeInjection,
                javascriptCodeInjection: summary.metadata.javascriptCodeInjection,
                structuredDataCodeInjection: summary.metadata.structuredDataCodeInjection
            )
        )
    }
}
