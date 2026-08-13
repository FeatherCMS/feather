import AsyncHTTPClient
import FeatherAdmin
import FeatherContracts
import Foundation
import NIOCore
import NewsAppAPI
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import SystemApplication
import WebApplication

public enum NewsWebPublicContentEventHandlers {
    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: WebPublicContentProvider.self,
            context: WebPublicContentEventContext.self
        ) { event, _ in
            try await resolve(event.request)
        }
    }

    private static func resolve(
        _ request: WebPublicContentEventContext
    ) async throws -> WebPublicContentResult? {
        let client = NewsAppAPI.Client(
            serverURL: FeatherAdmin.AppEnvironmentStore.current.apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [
                FeatherAdmin.ClientAPIAuthMiddleware(
                    sessionToken: request.sessionToken
                )
            ]
        )

        switch request.templateIdentifier {
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
        default:
            return try await resolveDetail(request, client: client)
        }
    }

    private static func resolveDetail(
        _ request: WebPublicContentEventContext,
        client: NewsAppAPI.Client
    ) async throws -> WebPublicContentResult? {
        guard !request.referenceID.isEmpty else { return nil }
        switch request.referenceType {
        case "news.article":
            let response = try await client.newsArticleGet(
                .init(path: .init(id: request.referenceID))
            )
            guard case .ok(let value) = response else { return nil }
            return .init(
                payload: ["page": pageContext(try value.body.json)]
            )
        case "news.category":
            let response = try await client.newsCategoryGet(
                .init(path: .init(id: request.referenceID))
            )
            guard case .ok(let value) = response else { return nil }
            return .init(
                payload: ["page": pageContext(try value.body.json)]
            )
        default:
            return nil
        }
    }

    private static func summaryContext(
        _ value: NewsAppAPI.Components.Schemas.NewsArticleSummarySchema
    ) -> [String: Any] {
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
    ) -> [String: Any] {
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
    ) -> [String: Any] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug
        )
        result["contents"] = ["html": value.content]
        result["categories"] = value.categories.map(summaryContext)
        result["noindex"] = value.metadata.status != "published"
            || value.metadata.noIndex
        return result
    }

    private static func pageContext(
        _ value: NewsAppAPI.Components.Schemas.NewsCategoryDetailSchema
    ) -> [String: Any] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug
        )
        result["contents"] = ["html": value.content]
        result["news"] = value.news.map(summaryContext)
        result["noindex"] = value.metadata.status != "published"
            || value.metadata.noIndex
        return result
    }

    private static func baseContext(
        id: String,
        title: String,
        description: String,
        image: String,
        permalink: String
    ) -> [String: Any] {
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
