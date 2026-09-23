import BlogAppAPI
import FeatherAdmin
import FeatherContracts
import Foundation
import OpenAPIRuntime
import SystemContracts
import WebContracts
import WebFrontend

public enum BlogWebPublicContentEventHandlers {
    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: WebPublicContentProvider.self,
            context: WebPublicContentEventContext<RuntimeBuilderContext>.self
        ) { _, context in
            try await resolve(context)
        }
    }

    private static func resolve(
        _ context: WebPublicContentEventContext<RuntimeBuilderContext>
    ) async throws -> WebPublicContentResult? {
        let api = BlogAppAPIClient(
            apiBaseURL: unsafe AppEnvironmentStore.current.apiBaseURL,
            sessionToken: context.runtime.1.sessionToken
        )

        if let kind = kind(for: context) {
            return try await resolveList(kind: kind, api: api)
        }
        switch context.baseMetadata.template {
        case "blog.post":
            return try await resolvePost(context: context, api: api)
        case "blog.author":
            return try await resolveAuthor(context: context, api: api)
        case "blog.tag":
            return try await resolveTag(context: context, api: api)
        default:
            return nil
        }
    }

    private static func resolvePost(
        context: WebPublicContentEventContext<RuntimeBuilderContext>,
        api: BlogAppAPIClient
    ) async throws -> WebPublicContentResult? {
        guard !context.baseMetadata.referenceId.isEmpty else { return nil }
        let referenceID = context.baseMetadata.referenceId
        let response = try await api.withOpenAPIRepositoryErrorMapping {
            client in
            try await client.blogPostGet(.init(path: .init(id: referenceID)))
        }
        guard case .ok(let value) = response else { return nil }
        return .init(payload: ["page": pageContext(try value.body.json)])
    }

    private static func resolveAuthor(
        context: WebPublicContentEventContext<RuntimeBuilderContext>,
        api: BlogAppAPIClient
    ) async throws -> WebPublicContentResult? {
        guard !context.baseMetadata.referenceId.isEmpty else { return nil }
        let referenceID = context.baseMetadata.referenceId
        let response = try await api.withOpenAPIRepositoryErrorMapping {
            client in
            try await client.blogAuthorGet(.init(path: .init(id: referenceID)))
        }
        guard case .ok(let value) = response else { return nil }
        return .init(payload: ["page": pageContext(try value.body.json)])
    }

    private static func resolveTag(
        context: WebPublicContentEventContext<RuntimeBuilderContext>,
        api: BlogAppAPIClient
    ) async throws -> WebPublicContentResult? {
        guard !context.baseMetadata.referenceId.isEmpty else { return nil }
        let referenceID = context.baseMetadata.referenceId
        let response = try await api.withOpenAPIRepositoryErrorMapping {
            client in
            try await client.blogTagGet(.init(path: .init(id: referenceID)))
        }
        guard case .ok(let value) = response else { return nil }
        return .init(payload: ["page": pageContext(try value.body.json)])
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
        for context: WebPublicContentEventContext<RuntimeBuilderContext>
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
    ) throws -> WebPublicContentResult {
        .init(payload: [key: items])
    }

    private static func summaryContext(
        _ value: BlogAppAPI.Components.Schemas.BlogPostSummarySchema
    ) -> [String: any Sendable] {
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
    ) -> [String: any Sendable] {
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
    ) -> [String: any Sendable] {
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
    ) -> [String: any Sendable] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate
        )
        result["contents"] = ["html": value.content] as [String: any Sendable]
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
    ) -> [String: any Sendable] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate
        )
        result["contents"] = ["html": value.content] as [String: any Sendable]
        result["posts"] = value.posts.map(summaryContext)
        result["postCountLabel"] = "\(value.posts.count) posts"
        result["noindex"] =
            value.metadata.status != "published"
            || value.metadata.noIndex
        return result
    }

    private static func pageContext(
        _ value: BlogAppAPI.Components.Schemas.BlogTagDetailSchema
    ) -> [String: any Sendable] {
        var result = baseContext(
            id: value.id,
            title: value.metadata.title,
            description: value.metadata.excerpt,
            image: value.imageURL,
            permalink: value.metadata.slug,
            publicationDate: value.metadata.publicationDate
        )
        result["contents"] = ["html": value.content] as [String: any Sendable]
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
    ) -> [String: any Sendable] {
        let resolvedImageURL = unsafe AppEnvironmentStore.current.mediaResolver
            .resolve(imagePath: image) ?? ""
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
            result["publicationLabel"] = ISO8601DateFormatter()
                .string(
                    from: Date(timeIntervalSince1970: publicationDate)
                )
        }
        return result
    }

}
