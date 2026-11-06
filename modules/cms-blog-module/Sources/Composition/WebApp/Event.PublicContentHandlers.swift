import BlogAppAPI
import BlogWebShared
public import FeatherModuleKit
import FeatherWebApp
import FeatherWebShared
import Foundation
import OpenAPIRuntime
import SystemModule
import WebModule
import WebModuleWebApp
import WebAppAPI

public enum PublicContent {
    public enum Event {
        public enum Handlers {
            public static func register(
                in registry: inout EventRegistry
            ) {
                registry.register(
                    event: WebModule.Public.Content.Event.Provider.self,
                    context: WebModule.Public.Content.Event.Context<
                        PublicContentRuntimeContext
                    >
                    .self
                ) { _, context in
                    try await PublicContent.resolve(context)
                }
            }
        }
    }

    private static func resolve(
        _ context: WebModule.Public.Content.Event.Context<
            PublicContentRuntimeContext
        >
    ) async throws -> WebModule.Public.Content.Result? {
        guard
            kind(for: context) != nil
                || ["blog.post", "blog.author", "blog.tag"].contains(
                    context.baseMetadata.template
                )
        else {
            return nil
        }
        let api = API.Client(
            apiBaseURL: context.runtime.apiBaseURL,
            sessionToken: context.runtime.context.sessionToken
        )
        let mediaResolver = context.runtime.mediaResolver
        let webAPI = WebModuleWebApp.API.Client(
            apiBaseURL: context.runtime.apiBaseURL,
            sessionToken: context.runtime.context.sessionToken
        )
        let siteSettingsResponse = try await webAPI.client.siteSettings(
            .init()
        )
        let dateFormatter: PublicDateFormatter
        switch siteSettingsResponse {
        case .ok(let value):
            let siteSettings = try value.body.json
            dateFormatter = .init(
                locale: siteSettings.locale,
                timezone: siteSettings.timezone
            )
        case .undocumented(let statusCode, let response):
            throw try await webAPI.failure(
                statusCode: statusCode,
                responseBody: response.body
            )
        }

        if let kind = kind(for: context) {
            return try await resolveList(
                kind: kind,
                api: api,
                mediaResolver: mediaResolver,
                dateFormatter: dateFormatter
            )
        }
        switch context.baseMetadata.template {
        case "blog.post":
            return try await resolvePost(
                context: context,
                api: api,
                mediaResolver: mediaResolver,
                dateFormatter: dateFormatter
            )
        case "blog.author":
            return try await resolveAuthor(
                context: context,
                api: api,
                mediaResolver: mediaResolver,
                dateFormatter: dateFormatter
            )
        case "blog.tag":
            return try await resolveTag(
                context: context,
                api: api,
                mediaResolver: mediaResolver,
                dateFormatter: dateFormatter
            )
        default:
            return nil
        }
    }

    private static func resolvePost(
        context: WebModule.Public.Content.Event.Context<
            PublicContentRuntimeContext
        >,
        api: API.Client,
        mediaResolver: MediaResolver,
        dateFormatter: PublicDateFormatter
    ) async throws -> WebModule.Public.Content.Result? {
        guard !context.baseMetadata.referenceId.isEmpty else { return nil }
        let referenceID = context.baseMetadata.referenceId
        let response = try await api.withOpenAPIRepositoryErrorMapping {
            client in
            try await client.blogPostGet(.init(path: .init(id: referenceID)))
        }
        guard case .ok(let value) = response else { return nil }
        return .init(
            payload: [
                "page": pageContext(
                    try value.body.json,
                    mediaResolver: mediaResolver,
                    dateFormatter: dateFormatter
                )
            ]
        )
    }

    private static func resolveAuthor(
        context: WebModule.Public.Content.Event.Context<
            PublicContentRuntimeContext
        >,
        api: API.Client,
        mediaResolver: MediaResolver,
        dateFormatter: PublicDateFormatter
    ) async throws -> WebModule.Public.Content.Result? {
        guard !context.baseMetadata.referenceId.isEmpty else { return nil }
        let referenceID = context.baseMetadata.referenceId
        let response = try await api.withOpenAPIRepositoryErrorMapping {
            client in
            try await client.blogAuthorGet(.init(path: .init(id: referenceID)))
        }
        guard case .ok(let value) = response else { return nil }
        return .init(
            payload: [
                "page": pageContext(
                    try value.body.json,
                    mediaResolver: mediaResolver,
                    dateFormatter: dateFormatter
                )
            ]
        )
    }

    private static func resolveTag(
        context: WebModule.Public.Content.Event.Context<
            PublicContentRuntimeContext
        >,
        api: API.Client,
        mediaResolver: MediaResolver,
        dateFormatter: PublicDateFormatter
    ) async throws -> WebModule.Public.Content.Result? {
        guard !context.baseMetadata.referenceId.isEmpty else { return nil }
        let referenceID = context.baseMetadata.referenceId
        let response = try await api.withOpenAPIRepositoryErrorMapping {
            client in
            try await client.blogTagGet(.init(path: .init(id: referenceID)))
        }
        guard case .ok(let value) = response else { return nil }
        return .init(
            payload: [
                "page": pageContext(
                    try value.body.json,
                    mediaResolver: mediaResolver,
                    dateFormatter: dateFormatter
                )
            ]
        )
    }

    private static func resolveList(
        kind: Kind,
        api: API.Client,
        mediaResolver: MediaResolver,
        dateFormatter: PublicDateFormatter
    ) async throws -> WebModule.Public.Content.Result {
        switch kind {
        case .posts:
            let value = try await api.withOpenAPIRepositoryErrorMapping {
                client in
                let response = try await client.blogPostList(.init())
                switch response {
                case .ok(let value): return try value.body.json
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
            return try listPayload(
                key: "posts",
                items: value.map {
                    summaryContext(
                        $0,
                        mediaResolver: mediaResolver,
                        dateFormatter: dateFormatter
                    )
                }
            )
        case .authors:
            let value = try await api.withOpenAPIRepositoryErrorMapping {
                client in
                let response = try await client.blogAuthorList(.init())
                switch response {
                case .ok(let value): return try value.body.json
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
            return try listPayload(
                key: "authors",
                items: value.map {
                    summaryContext(
                        $0,
                        mediaResolver: mediaResolver,
                        dateFormatter: dateFormatter
                    )
                }
            )
        case .tags:
            let value = try await api.withOpenAPIRepositoryErrorMapping {
                client in
                let response = try await client.blogTagList(.init())
                switch response {
                case .ok(let value): return try value.body.json
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
            return try listPayload(
                key: "tags",
                items: value.map {
                    summaryContext(
                        $0,
                        mediaResolver: mediaResolver,
                        dateFormatter: dateFormatter
                    )
                }
            )
        }
    }

    private enum Kind {
        case posts
        case authors
        case tags
    }

    private static func kind(
        for context: WebModule.Public.Content.Event.Context<
            PublicContentRuntimeContext
        >
    ) -> Kind? {
        switch context.baseMetadata.template {
        case "blog.posts":
            return .posts
        case "blog.authors":
            return .authors
        case "blog.tags":
            return .tags
        default:
            return nil
        }
    }

    private static func listPayload(
        key: String,
        items: [[String: any Sendable]]
    ) throws -> WebModule.Public.Content.Result {
        .init(payload: [key: items])
    }

    private static func summaryContext(
        _ value: BlogAppAPI.Components.Schemas.BlogPostSummarySchema,
        mediaResolver: MediaResolver,
        dateFormatter: PublicDateFormatter
    ) -> [String: any Sendable] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate,
            mediaResolver: mediaResolver,
            dateFormatter: dateFormatter
        )
        result["authors"] = value.authors.map {
            summaryContext(
                $0,
                mediaResolver: mediaResolver,
                dateFormatter: dateFormatter
            )
        }
        result["tags"] = value.tags.map {
            summaryContext(
                $0,
                mediaResolver: mediaResolver,
                dateFormatter: dateFormatter
            )
        }
        return result
    }

    private static func summaryContext(
        _ value: BlogAppAPI.Components.Schemas.BlogAuthorSummarySchema,
        mediaResolver: MediaResolver,
        dateFormatter: PublicDateFormatter
    ) -> [String: any Sendable] {
        baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate,
            mediaResolver: mediaResolver,
            dateFormatter: dateFormatter
        )
    }

    private static func summaryContext(
        _ value: BlogAppAPI.Components.Schemas.BlogTagSummarySchema,
        mediaResolver: MediaResolver,
        dateFormatter: PublicDateFormatter
    ) -> [String: any Sendable] {
        baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate,
            mediaResolver: mediaResolver,
            dateFormatter: dateFormatter
        )
    }

    private static func pageContext(
        _ value: BlogAppAPI.Components.Schemas.BlogPostDetailSchema,
        mediaResolver: MediaResolver,
        dateFormatter: PublicDateFormatter
    ) -> [String: any Sendable] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate,
            mediaResolver: mediaResolver,
            dateFormatter: dateFormatter
        )
        result["contents"] = ["html": value.content] as [String: any Sendable]
        result["authors"] = value.authors.map {
            summaryContext(
                $0,
                mediaResolver: mediaResolver,
                dateFormatter: dateFormatter
            )
        }
        result["tags"] = value.tags.map {
            summaryContext(
                $0,
                mediaResolver: mediaResolver,
                dateFormatter: dateFormatter
            )
        }
        result["relatedPosts"] = value.relatedPosts.map {
            summaryContext(
                $0,
                mediaResolver: mediaResolver,
                dateFormatter: dateFormatter
            )
        }
        result["noindex"] =
            value.metadata.status != "published"
            || value.metadata.noIndex
        return result
    }

    private static func pageContext(
        _ value: BlogAppAPI.Components.Schemas.BlogAuthorDetailSchema,
        mediaResolver: MediaResolver,
        dateFormatter: PublicDateFormatter
    ) -> [String: any Sendable] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate,
            mediaResolver: mediaResolver,
            dateFormatter: dateFormatter
        )
        result["contents"] = ["html": value.content] as [String: any Sendable]
        result["posts"] = value.posts.map {
            summaryContext(
                $0,
                mediaResolver: mediaResolver,
                dateFormatter: dateFormatter
            )
        }
        result["postCountLabel"] = "\(value.posts.count) posts"
        result["noindex"] =
            value.metadata.status != "published"
            || value.metadata.noIndex
        return result
    }

    private static func pageContext(
        _ value: BlogAppAPI.Components.Schemas.BlogTagDetailSchema,
        mediaResolver: MediaResolver,
        dateFormatter: PublicDateFormatter
    ) -> [String: any Sendable] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate,
            mediaResolver: mediaResolver,
            dateFormatter: dateFormatter
        )
        result["contents"] = ["html": value.content] as [String: any Sendable]
        result["posts"] = value.posts.map {
            summaryContext(
                $0,
                mediaResolver: mediaResolver,
                dateFormatter: dateFormatter
            )
        }
        result["postCountLabel"] = "\(value.posts.count) posts"
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
        publicationDate: Double?,
        mediaResolver: MediaResolver,
        dateFormatter: PublicDateFormatter
    ) -> [String: any Sendable] {
        let resolvedImageURL = mediaResolver.resolve(imagePath: image) ?? ""
        var result: [String: any Sendable] = [
            "id": id,
            "title": title,
            "description": description,
            "hasImage": !resolvedImageURL.isEmpty,
            "permalink": permalink.hasPrefix("/")
                ? permalink
                : "/\(permalink)",
        ]
        if let image = resolvedImageURL.emptyToNil {
            result["image"] = image
        }
        if let publicationDate {
            result["publicationLabel"] = dateFormatter
                .formatDateTime(unixTimestamp: publicationDate)
        }
        return result
    }

}
