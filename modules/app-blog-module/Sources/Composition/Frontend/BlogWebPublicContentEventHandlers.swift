import BlogAppAPI
import FeatherAdmin
import FeatherContracts
import Foundation
import OpenAPIRuntime
import SystemApplication
import WebApplication

public enum BlogWebPublicContentEventHandlers {
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
        let api = BlogAppAPIClient(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: request.sessionToken
        )

        if let kind = kind(for: request) {
            return try await resolveList(kind: kind, api: api)
        }
        guard !request.referenceID.isEmpty else { return nil }
        switch request.referenceType {
        case "blog.post":
            let response = try await api.withOpenAPIRepositoryErrorMapping {
                client in
                try await client.blogPostGet(
                    .init(path: .init(id: request.referenceID))
                )
            }
            guard case .ok(let value) = response else { return nil }
            return .init(
                payload: ["page": pageContext(try value.body.json)]
            )
        case "blog.author":
            let response = try await api.withOpenAPIRepositoryErrorMapping {
                client in
                try await client.blogAuthorGet(
                    .init(path: .init(id: request.referenceID))
                )
            }
            guard case .ok(let value) = response else { return nil }
            return .init(
                payload: ["page": pageContext(try value.body.json)]
            )
        case "blog.tag":
            let response = try await api.withOpenAPIRepositoryErrorMapping {
                client in
                try await client.blogTagGet(
                    .init(path: .init(id: request.referenceID))
                )
            }
            guard case .ok(let value) = response else { return nil }
            return .init(
                payload: ["page": pageContext(try value.body.json)]
            )
        default:
            return nil
        }
    }

    private static func resolveList(
        kind: Kind,
        api: BlogAppAPIClient
    ) async throws -> WebPublicContentResult {
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
                items: value.map(summaryContext)
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
                items: value.map(summaryContext)
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
                items: value.map(summaryContext)
            )
        }
    }

    private enum Kind {
        case posts
        case authors
        case tags
    }

    private static func kind(
        for request: WebPublicContentEventContext
    ) -> Kind? {
        switch request.templateIdentifier {
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
        items: [[String: Any]]
    ) throws -> WebPublicContentResult {
        .init(payload: [key: items])
    }

    private static func summaryContext(
        _ value: BlogAppAPI.Components.Schemas.BlogPostSummarySchema
    ) -> [String: Any] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate
        )
        result["authors"] = value.authors.map(summaryContext)
        result["tags"] = value.tags.map(summaryContext)
        return result
    }

    private static func summaryContext(
        _ value: BlogAppAPI.Components.Schemas.BlogAuthorSummarySchema
    ) -> [String: Any] {
        baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate
        )
    }

    private static func summaryContext(
        _ value: BlogAppAPI.Components.Schemas.BlogTagSummarySchema
    ) -> [String: Any] {
        baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate
        )
    }

    private static func pageContext(
        _ value: BlogAppAPI.Components.Schemas.BlogPostDetailSchema
    ) -> [String: Any] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate
        )
        result["contents"] = ["html": value.content]
        result["authors"] = value.authors.map(summaryContext)
        result["tags"] = value.tags.map(summaryContext)
        result["relatedPosts"] = value.relatedPosts.map(summaryContext)
        result["noindex"] =
            value.metadata.status != "published"
            || value.metadata.noIndex
        return result
    }

    private static func pageContext(
        _ value: BlogAppAPI.Components.Schemas.BlogAuthorDetailSchema
    ) -> [String: Any] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate
        )
        result["contents"] = ["html": value.content]
        result["posts"] = value.posts.map(summaryContext)
        result["postCountLabel"] = "\(value.posts.count) posts"
        result["noindex"] =
            value.metadata.status != "published"
            || value.metadata.noIndex
        return result
    }

    private static func pageContext(
        _ value: BlogAppAPI.Components.Schemas.BlogTagDetailSchema
    ) -> [String: Any] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate
        )
        result["contents"] = ["html": value.content]
        result["posts"] = value.posts.map(summaryContext)
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
        publicationDate: Double?
    ) -> [String: Any] {
        let resolvedImageURL = WebImageURLResolver.resolve(
            image,
            mediaBaseURL: mediaBaseURL
        )
        var result: [String: Any] = [
            "id": id,
            "title": title,
            "description": description,
            "image": resolvedImageURL,
            "hasImage": !resolvedImageURL.isEmpty,
            "permalink": permalink.hasPrefix("/")
                ? permalink
                : "/\(permalink)",
        ]
        if let publicationDate {
            result["publicationLabel"] = ISO8601DateFormatter()
                .string(
                    from: Date(timeIntervalSince1970: publicationDate)
                )
        }
        return result
    }

    private static var mediaBaseURL: String {
        AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString
    }

}
