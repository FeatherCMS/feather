import Application
import Foundation

public struct GetPublicBlogRouteSettings {
    let query: any QueryExecutor<ReadVariable>

    public init(
        query: any QueryExecutor<ReadVariable>
    ) {
        self.query = query
    }

    public func execute() async throws -> PublicBlogRouteSettings {
        let postListPath = try await value(
            for: "blog.post.list_path",
            default: "blog"
        )
        let authorListPath = try await value(
            for: "blog.author.list_path",
            default: "authors"
        )
        let tagListPath = try await value(
            for: "blog.tag.list_path",
            default: "tags"
        )
        let postPathPrefix = try await value(
            for: "blog.post.path_prefix",
            default: "posts"
        )
        let authorPathPrefix = try await value(
            for: "blog.author.path_prefix",
            default: "authors"
        )
        let tagPathPrefix = try await value(
            for: "blog.tag.path_prefix",
            default: "tags"
        )
        let siteNoIndex = try await boolValue(
            for: "web.site.no_index",
            default: false
        )

        return .init(
            postListPath: postListPath,
            authorListPath: authorListPath,
            tagListPath: tagListPath,
            postPathPrefix: postPathPrefix,
            authorPathPrefix: authorPathPrefix,
            tagPathPrefix: tagPathPrefix,
            siteNoIndex: siteNoIndex
        )
    }
}

private extension GetPublicBlogRouteSettings {
    func value(
        for key: String,
        default defaultValue: String
    ) async throws -> String {
        let stored = try await query.run { context in
            let items = try await context.variable.list(
                query: .init(
                    page: .init(size: 10, number: 1),
                    search: key
                )
            )
            return items.items.first { $0.name == key }?.value ?? defaultValue
        }
        return normalize(stored)
    }

    func normalize(
        _ value: String
    ) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }

    func boolValue(
        for key: String,
        default defaultValue: Bool
    ) async throws -> Bool {
        let stored = try await query.run { context in
            let items = try await context.variable.list(
                query: .init(
                    page: .init(size: 10, number: 1),
                    search: key
                )
            )
            return items.items.first { $0.name == key }?.value
        }
        guard let stored else {
            return defaultValue
        }
        return stored == "true"
    }
}
