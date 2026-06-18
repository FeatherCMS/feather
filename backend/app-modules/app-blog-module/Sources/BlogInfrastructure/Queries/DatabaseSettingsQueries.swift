import BlogApplication
import FeatherDatabase
import Foundation
import Infrastructure

public struct DatabaseSettingsQueries: SettingsQueries {
    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func get() async throws -> SettingsDetail {
        let pairs = try await connection.run(
            query: #"""
                SELECT name, value
                FROM system_variable
                WHERE name IN (
                    'blog.post.list_path',
                    'blog.author.list_path',
                    'blog.tag.list_path',
                    'blog.post.path_prefix',
                    'blog.author.path_prefix',
                    'blog.tag.path_prefix'
                );
                """#
        ) { sequence in
            let rows = try await sequence.collect()
            return try rows.reduce(into: [String: String]()) { result, row in
                let name = try row.decode(column: "name", as: String.self)
                let value = try row.decode(column: "value", as: String.self)
                result[name] = value
            }
        }

        return .init(
            id: "blog-settings",
            postListPath: normalize(pairs["blog.post.list_path"] ?? "blog"),
            authorListPath: normalize(
                pairs["blog.author.list_path"] ?? "authors"
            ),
            tagListPath: normalize(pairs["blog.tag.list_path"] ?? "tags"),
            postPathPrefix: normalize(
                pairs["blog.post.path_prefix"] ?? "posts"
            ),
            authorPathPrefix: normalize(
                pairs["blog.author.path_prefix"] ?? "authors"
            ),
            tagPathPrefix: normalize(pairs["blog.tag.path_prefix"] ?? "tags")
        )
    }

    private func normalize(
        _ value: String
    ) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
}
