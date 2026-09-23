import AsyncHTTPClient
import FeatherAdmin
public import FeatherContracts
import Foundation
import NIOCore
import NewsAppAPI
import OpenAPIAsyncHTTPClient
import WebContracts

public enum NewsWebPublicContentEventHandlers {
    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: WebPublicContentProvider.self,
            context: WebPublicContentEventContext<PublicContentRuntimeContext>.self
        ) { _, context in
            try await resolve(context)
        }
    }

    private static func resolve(
        _ context: WebPublicContentEventContext<PublicContentRuntimeContext>
    ) async throws -> WebPublicContentResult? {
        let mediaResolver = context.runtime.mediaResolver
        // TODO: fix this
        let client = NewsAppAPI.Client(
            serverURL: context.runtime.apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [
                FeatherAdmin.ClientAPIAuthMiddleware(
                    sessionToken: context.runtime.context.sessionToken
                )
            ]
        )

        switch context.baseMetadata.template {
        case "news.categories":
            let response = try await client.newsCategoryList(.init())
            switch response {
            case .ok(let value):
                return .init(
                    payload: [
                        "items": try value.body.json.map {
                            summaryContext($0, mediaResolver: mediaResolver)
                        }
                    ]
                )
            case .undocumented:
                return nil
            }
        case "news.articles":
            let response = try await client.newsArticleList(.init())
            switch response {
            case .ok(let value):
                return .init(
                    payload: [
                        "items": try value.body.json.map {
                            summaryContext($0, mediaResolver: mediaResolver)
                        }
                    ]
                )
            case .undocumented:
                return nil
            }
        case "news.article":
            return try await resolveArticle(
                context: context,
                client: client,
                mediaResolver: mediaResolver
            )
        case "news.category":
            return try await resolveCategory(
                context: context,
                client: client,
                mediaResolver: mediaResolver
            )
        default:
            return nil
        }
    }

    private static func resolveArticle(
        context: WebPublicContentEventContext<PublicContentRuntimeContext>,
        client: NewsAppAPI.Client,
        mediaResolver: MediaResolver
    ) async throws -> WebPublicContentResult? {
        guard !context.baseMetadata.referenceId.isEmpty else { return nil }
        let referenceID = context.baseMetadata.referenceId
        let response = try await client.newsArticleGet(
            .init(path: .init(id: referenceID))
        )
        guard case .ok(let value) = response else { return nil }
        return .init(
            payload: [
                "page": pageContext(
                    try value.body.json,
                    mediaResolver: mediaResolver
                )
            ]
        )
    }

    private static func resolveCategory(
        context: WebPublicContentEventContext<PublicContentRuntimeContext>,
        client: NewsAppAPI.Client,
        mediaResolver: MediaResolver
    ) async throws -> WebPublicContentResult? {
        guard !context.baseMetadata.referenceId.isEmpty else { return nil }
        let referenceID = context.baseMetadata.referenceId
        let response = try await client.newsCategoryGet(
            .init(path: .init(id: referenceID))
        )
        guard case .ok(let value) = response else { return nil }
        return .init(
            payload: [
                "page": pageContext(
                    try value.body.json,
                    mediaResolver: mediaResolver
                )
            ]
        )
    }

    private static func summaryContext(
        _ value: NewsAppAPI.Components.Schemas.NewsArticleSummarySchema,
        mediaResolver: MediaResolver
    ) -> [String: any Sendable] {
        baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            mediaResolver: mediaResolver
        )
    }

    private static func summaryContext(
        _ value: NewsAppAPI.Components.Schemas.NewsCategorySummarySchema,
        mediaResolver: MediaResolver
    ) -> [String: any Sendable] {
        baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            mediaResolver: mediaResolver
        )
    }

    private static func pageContext(
        _ value: NewsAppAPI.Components.Schemas.NewsArticleDetailSchema,
        mediaResolver: MediaResolver
    ) -> [String: any Sendable] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            mediaResolver: mediaResolver
        )
        result["contents"] = ["html": value.content] as [String: any Sendable]
        result["categories"] = value.categories.map {
            summaryContext($0, mediaResolver: mediaResolver)
        }
        result["noindex"] =
            value.metadata.status != "published"
            || value.metadata.noIndex
        return result
    }

    private static func pageContext(
        _ value: NewsAppAPI.Components.Schemas.NewsCategoryDetailSchema,
        mediaResolver: MediaResolver
    ) -> [String: any Sendable] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            mediaResolver: mediaResolver
        )
        result["contents"] = ["html": value.content] as [String: any Sendable]
        result["news"] = value.news.map {
            summaryContext($0, mediaResolver: mediaResolver)
        }
        result["noindex"] =
            value.metadata.status != "published"
            || value.metadata.noIndex
        return result
    }

    private static func baseContext(
        id: String,
        title: String,
        description: String,
        image: String,
        permalink: String,
        mediaResolver: MediaResolver
    ) -> [String: any Sendable] {
        let resolvedImageURL = mediaResolver.resolve(imagePath: image) ?? ""
        return [
            "id": id,
            "title": title,
            "description": description,
            "image": resolvedImageURL,
            "hasImage": !resolvedImageURL.isEmpty,
            "permalink": permalink.hasPrefix("/")
                ? permalink
                : "/\(permalink)",
        ]
    }

}
