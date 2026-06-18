import BlogApplication
import BlogDomain
import FeatherDatabase
import Infrastructure

public struct DatabaseSettingsRepository: SettingsRepository {
    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func get() async throws -> Settings {
        let detail = try await DatabaseSettingsQueries(connection: connection)
            .get()
        return .init(
            id: detail.id,
            postListPath: detail.postListPath,
            authorListPath: detail.authorListPath,
            tagListPath: detail.tagListPath,
            postPathPrefix: detail.postPathPrefix,
            authorPathPrefix: detail.authorPathPrefix,
            tagPathPrefix: detail.tagPathPrefix
        )
    }

    public func update(
        _ model: Settings
    ) async throws -> Settings {
        try await upsert(
            id: "blog-settings-post-list-path",
            name: "blog.post.list_path",
            value: model.postListPath,
            notes: "Public blog post list path."
        )
        try await upsert(
            id: "blog-settings-author-list-path",
            name: "blog.author.list_path",
            value: model.authorListPath,
            notes: "Public blog author list path."
        )
        try await upsert(
            id: "blog-settings-tag-list-path",
            name: "blog.tag.list_path",
            value: model.tagListPath,
            notes: "Public blog tag list path."
        )
        try await upsert(
            id: "blog-settings-post-path-prefix",
            name: "blog.post.path_prefix",
            value: model.postPathPrefix,
            notes: "Public blog post detail path prefix."
        )
        try await upsert(
            id: "blog-settings-author-path-prefix",
            name: "blog.author.path_prefix",
            value: model.authorPathPrefix,
            notes: "Public blog author detail path prefix."
        )
        try await upsert(
            id: "blog-settings-tag-path-prefix",
            name: "blog.tag.path_prefix",
            value: model.tagPathPrefix,
            notes: "Public blog tag detail path prefix."
        )
        return try await get()
    }

    private func upsert(
        id: String,
        name: String,
        value: String,
        notes: String
    ) async throws {
        _ = try await connection.run(
            query: #"""
                INSERT INTO system_variable (
                    id,
                    name,
                    value,
                    notes,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(id),
                    \#(name),
                    \#(value),
                    \#(notes),
                    NOW(),
                    NOW()
                )
                ON CONFLICT (name) DO UPDATE SET
                    value=EXCLUDED.value,
                    notes=EXCLUDED.notes,
                    updated_at=NOW()
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
