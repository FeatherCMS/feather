import FeatherModuleKit
import Foundation
public import NewsAppAPI
import NewsApplication
import WebApplication
import WebDomain
import WebModule

extension AppAPIGateway {

    public func newsArticleList(
        _: Operations.NewsArticleList.Input
    ) async throws -> Operations.NewsArticleList.Output {
        let output = try await useCases.makeListPublicArticles()
            .execute(
                input: .init()
            )
        var items: [Components.Schemas.NewsArticleSummarySchema] = []
        items.reserveCapacity(output.items.count)
        for item in output.items {
            items.append(await mapArticleSummary(item))
        }
        return .ok(.init(body: .json(items)))
    }

    public func newsArticleGet(
        _ input: Operations.NewsArticleGet.Input
    ) async throws -> Operations.NewsArticleGet.Output {
        do {
            let item = try await useCases.makeDetailPublicArticle()
                .execute(input: .init(id: input.path.id))
            return .ok(.init(body: .json(await mapArticleDetail(item))))
        }
        catch {
            return .notFound(
                .init(
                    body: .json(
                        notFoundErrorEnvelope(
                            message: "Not Found",
                            reason: "News article not found"
                        )
                    )
                )
            )
        }
    }

    public func newsCategoryList(
        _: Operations.NewsCategoryList.Input
    ) async throws -> Operations.NewsCategoryList.Output {
        let output = try await useCases.makeListPublicCategories().execute()
        var items: [Components.Schemas.NewsCategorySummarySchema] = []
        items.reserveCapacity(output.items.count)
        for item in output.items {
            items.append(await mapCategorySummary(item))
        }
        return .ok(.init(body: .json(items)))
    }

    public func newsCategoryGet(
        _ input: Operations.NewsCategoryGet.Input
    ) async throws -> Operations.NewsCategoryGet.Output {
        do {
            let item = try await useCases.makeDetailPublicCategory()
                .execute(input: .init(id: input.path.id))
            return .ok(.init(body: .json(await mapCategoryDetail(item))))
        }
        catch {
            return .notFound(
                .init(
                    body: .json(
                        notFoundErrorEnvelope(
                            message: "Not Found",
                            reason: "News category not found"
                        )
                    )
                )
            )
        }
    }
}

private func notFoundErrorEnvelope(
    message: String,
    reason: String
) -> Components.Schemas.DefaultHTTPErrorContentSchemaHTTPErrorEnvelopeSchema {
    .init(error: .init(message: message, reason: reason))
}

extension AppAPIGateway {
    fileprivate func mapArticleSummary(
        _ item: NewsApplication.Public.Article.Summary.Item
    ) async -> Components.Schemas.NewsArticleSummarySchema {
        let media = await publicMedia(assetId: item.imageAssetId)
        let imageURL = media?.defaultURL ?? item.imageURL
        return .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageURL: imageURL,
            media: mapMedia(media),
            metadata: mapMetadata(
                item.metadata,
                title: item.title,
                excerpt: item.excerpt,
                imageURL: imageURL
            )
        )
    }

    fileprivate func mapArticleDetail(
        _ item: NewsApplication.Public.Article.Detail.Output
    ) async -> Components.Schemas.NewsArticleDetailSchema {
        let media = await publicMedia(assetId: item.imageAssetId)
        let imageURL = media?.defaultURL ?? item.imageURL
        var categories: [Components.Schemas.NewsCategorySummarySchema] = []
        categories.reserveCapacity(item.categories.count)
        for category in item.categories {
            categories.append(await mapCategorySummary(category))
        }
        return .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            content: item.content,
            imageURL: imageURL,
            media: mapMedia(media),
            metadata: mapMetadata(
                item.metadata,
                title: item.title,
                excerpt: item.excerpt,
                imageURL: imageURL
            ),
            categories: categories
        )
    }

    fileprivate func mapCategorySummary(
        _ item: NewsApplication.Public.Category.Summary.Item
    ) async -> Components.Schemas.NewsCategorySummarySchema {
        let media = await publicMedia(assetId: item.imageAssetId)
        let imageURL = media?.defaultURL ?? item.imageURL
        return .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageURL: imageURL,
            media: mapMedia(media),
            metadata: mapMetadata(
                item.metadata,
                title: item.title,
                excerpt: item.excerpt,
                imageURL: imageURL
            )
        )
    }

    fileprivate func mapCategoryDetail(
        _ item: NewsApplication.Public.Category.Detail.Output
    ) async -> Components.Schemas.NewsCategoryDetailSchema {
        let media = await publicMedia(assetId: item.imageAssetId)
        let imageURL = media?.defaultURL ?? item.imageURL
        var news: [Components.Schemas.NewsArticleSummarySchema] = []
        news.reserveCapacity(item.articles.count)
        for article in item.articles {
            news.append(await mapArticleSummary(article))
        }
        return .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            content: item.content,
            imageURL: imageURL,
            media: mapMedia(media),
            metadata: mapMetadata(
                item.metadata,
                title: item.title,
                excerpt: item.excerpt,
                imageURL: imageURL
            ),
            news: news
        )
    }

    fileprivate func mapMedia(
        _ media: WebApplication.Public.Media?
    ) -> Components.Schemas.MediaAssetSchema? {
        guard let media else { return nil }
        return .init(
            assetId: media.assetId,
            originalURL: media.originalURL,
            defaultURL: media.defaultURL,
            variants: media.variants.map {
                .init(
                    key: $0.key,
                    url: $0.url
                )
            }
        )
    }

    fileprivate func mapMetadata(
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
        return .init(
            slug: metadata.slug,
            template: metadata.template,
            publicationDate: metadata.publicationDate.timeIntervalSince1970,
            expirationDate: metadata.expirationDate?.timeIntervalSince1970,
            status: metadata.status.rawValue,
            title: resolved.title,
            excerpt: resolved.excerpt,
            imageURL: resolved.imageURL ?? "",
            canonicalURL: metadata.canonicalURL ?? "",
            noIndex: metadata.noIndex,
            cssCodeInjection: metadata.cssCodeInjection ?? "",
            javascriptCodeInjection: metadata.javascriptCodeInjection ?? "",
            structuredDataCodeInjection: metadata.structuredDataCodeInjection
                ?? ""
        )
    }
}
