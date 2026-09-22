import AsyncHTTPClient
import Foundation

import FeatherAdmin
import FeatherContracts
import NIOCore
import NewsAppAPI
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import SystemContracts
import WebContracts
import WebFrontend

public enum NewsWebPublicContentEventHandlers {
    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: WebPublicContentProvider.self,
            context: WebPublicContentEventContext.self
        ) { _, context in
            try await resolve(context)
        }
    }

    private static func resolve(
        _ context: WebPublicContentEventContext
    ) async throws -> WebPublicContentResult? {
        let client = NewsAppAPI.Client(
            serverURL: FeatherAdmin.AppEnvironmentStore.current.apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [
                FeatherAdmin.ClientAPIAuthMiddleware(
                    sessionToken: context.sessionToken
                )
            ]
        )

        switch context.templateIdentifier {
        case "news.categories":
            let response = try await client.newsCategoryList(.init())
            switch response {
            case .ok(let value):
                return .init(
                    payload: [
                        "items": try value.body.json.map(summaryContext)
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
                        "items": try value.body.json.map(summaryContext)
                    ]
                )
            case .undocumented:
                return nil
            }
        case "news.article":
            return try await resolveArticle(context: context, client: client)
        case "news.category":
            return try await resolveCategory(context: context, client: client)
        default:
            return nil
        }
    }

    private static func resolveArticle(
        context: WebPublicContentEventContext,
        client: NewsAppAPI.Client
    ) async throws -> WebPublicContentResult? {
        guard let referenceID = context.referenceID else { return nil }
        let response = try await client.newsArticleGet(
            .init(path: .init(id: referenceID))
        )
        guard case .ok(let value) = response else { return nil }
        return .init(
            payload: ["page": pageContext(try value.body.json)]
        )
    }

    private static func resolveCategory(
        context: WebPublicContentEventContext,
        client: NewsAppAPI.Client
    ) async throws -> WebPublicContentResult? {
        guard let referenceID = context.referenceID else { return nil }
        let response = try await client.newsCategoryGet(
            .init(path: .init(id: referenceID))
        )
        guard case .ok(let value) = response else { return nil }
        return .init(
            payload: ["page": pageContext(try value.body.json)]
        )
    }

    private static func summaryContext(
        _ value: NewsAppAPI.Components.Schemas.NewsArticleSummarySchema
    ) -> [String: any Sendable] {
        baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug
        )
    }

    private static func summaryContext(
        _ value: NewsAppAPI.Components.Schemas.NewsCategorySummarySchema
    ) -> [String: any Sendable] {
        baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug
        )
    }

    private static func pageContext(
        _ value: NewsAppAPI.Components.Schemas.NewsArticleDetailSchema
    ) -> [String: any Sendable] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug
        )
        result["contents"] = ["html": value.content] as [String: any Sendable]
        result["categories"] = value.categories.map(summaryContext)
        result["noindex"] =
            value.metadata.status != "published"
            || value.metadata.noIndex
        return result
    }

    private static func pageContext(
        _ value: NewsAppAPI.Components.Schemas.NewsCategoryDetailSchema
    ) -> [String: any Sendable] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug
        )
        result["contents"] = ["html": value.content] as [String: any Sendable]
        result["news"] = value.news.map(summaryContext)
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
        permalink: String
    ) -> [String: any Sendable] {
        let resolvedImageURL = WebImageURLResolver.resolve(
            image,
            mediaBaseURL: mediaBaseURL
        )
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

    private static var mediaBaseURL: String {
        FeatherAdmin.AppEnvironmentStore.current.publicOrigins.mediaBaseURL
            .absoluteString
    }

}
