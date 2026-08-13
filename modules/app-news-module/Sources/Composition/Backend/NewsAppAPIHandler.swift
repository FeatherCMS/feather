import Foundation
import NewsAppAPI
import NewsApplication
import WebApplication
import WebDomain

public struct NewsAppAPIHandler: NewsAppAPI.APIProtocol, Sendable {
    private let news: NewsBackend

    public init(news: NewsBackend) {
        self.news = news
    }

    public func newsArticleList(
        _: Operations.NewsArticleList.Input
    ) async throws -> Operations.NewsArticleList.Output {
        let items = try await news.makeListPublicArticles().execute()
        return .ok(.init(body: .json(items.map(mapArticleSummary))))
    }

    public func newsArticleGet(
        _ input: Operations.NewsArticleGet.Input
    ) async throws -> Operations.NewsArticleGet.Output {
        do {
            let item = try await news.makeGetPublicArticle()
                .execute(id: input.path.id)
            return .ok(.init(body: .json(mapArticleDetail(item))))
        }
        catch {
            return .notFound
        }
    }

    public func newsCategoryList(
        _: Operations.NewsCategoryList.Input
    ) async throws -> Operations.NewsCategoryList.Output {
        let items = try await news.makeListPublicCategories().execute()
        return .ok(.init(body: .json(items.map(mapCategorySummary))))
    }

    public func newsCategoryGet(
        _ input: Operations.NewsCategoryGet.Input
    ) async throws -> Operations.NewsCategoryGet.Output {
        do {
            let item = try await news.makeGetPublicCategory()
                .execute(id: input.path.id)
            return .ok(.init(body: .json(mapCategoryDetail(item))))
        }
        catch {
            return .notFound
        }
    }
}

extension NewsAppAPIHandler {
    fileprivate func mapArticleSummary(
        _ item: PublicNewsArticleSummary
    ) -> Components.Schemas.NewsArticleSummarySchema {
        .init(
            id: item.id,
            excerpt: item.excerpt,
            imageURL: item.media?.defaultURL ?? item.imageURL,
            media: mapMedia(item.media),
            metadata: mapMetadata(
                item.metadata,
                title: item.title,
                excerpt: item.excerpt,
                imageURL: item.media?.defaultURL ?? item.imageURL
            )
        )
    }

    fileprivate func mapArticleDetail(
        _ item: PublicNewsArticleDetail
    ) -> Components.Schemas.NewsArticleDetailSchema {
        .init(
            id: item.id,
            excerpt: item.excerpt,
            content: item.content,
            imageURL: item.media?.defaultURL ?? item.imageURL,
            media: mapMedia(item.media),
            metadata: mapMetadata(
                item.metadata,
                title: item.title,
                excerpt: item.excerpt,
                imageURL: item.media?.defaultURL ?? item.imageURL
            ),
            categories: item.categories.map(mapCategorySummary)
        )
    }

    fileprivate func mapCategorySummary(
        _ item: PublicNewsCategorySummary
    ) -> Components.Schemas.NewsCategorySummarySchema {
        .init(
            id: item.id,
            excerpt: item.excerpt,
            imageURL: item.media?.defaultURL ?? item.imageURL,
            media: mapMedia(item.media),
            metadata: mapMetadata(
                item.metadata,
                title: item.title,
                excerpt: item.excerpt,
                imageURL: item.media?.defaultURL ?? item.imageURL
            )
        )
    }

    fileprivate func mapCategoryDetail(
        _ item: PublicNewsCategoryDetail
    ) -> Components.Schemas.NewsCategoryDetailSchema {
        .init(
            id: item.id,
            excerpt: item.excerpt,
            content: item.content,
            imageURL: item.media?.defaultURL ?? item.imageURL,
            media: mapMedia(item.media),
            metadata: mapMetadata(
                item.metadata,
                title: item.title,
                excerpt: item.excerpt,
                imageURL: item.media?.defaultURL ?? item.imageURL
            ),
            news: item.articles.map(mapArticleSummary)
        )
    }

    fileprivate func mapMedia(
        _ media: PublicContentMedia?
    ) -> Components.Schemas.MediaAssetSchema? {
        guard let media else { return nil }
        return .init(
            assetId: media.assetId,
            originalURL: media.originalURL,
            defaultURL: media.defaultURL,
            variants: media.variants.map {
                .init(
                    id: $0.id,
                    url: $0.url,
                    _type: $0.type,
                    width: $0.width.map(Int64.init),
                    height: $0.height.map(Int64.init)
                )
            }
        )
    }

    fileprivate func mapMetadata(
        _ metadata: MetadataDetail,
        title: String,
        excerpt: String,
        imageURL: String
    ) -> Components.Schemas.WebMetadataContentSchema {
        .init(
            slug: metadata.slug,
            template: metadata.template,
            publicationDate: metadata.publicationDate.timeIntervalSince1970,
            expirationDate: metadata.expirationDate?.timeIntervalSince1970,
            status: metadata.status.rawValue,
            title: metadata.title ?? title,
            excerpt: metadata.excerpt ?? excerpt,
            imageURL: metadata.imageURL ?? imageURL,
            canonicalURL: metadata.canonicalURL,
            noIndex: metadata.noIndex,
            cssCodeInjection: metadata.cssCodeInjection,
            javascriptCodeInjection: metadata.javascriptCodeInjection,
            structuredDataCodeInjection: metadata.structuredDataCodeInjection
        )
    }
}
