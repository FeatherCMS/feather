import FeatherDatabase
import Infrastructure
import struct Foundation.Data
import struct Foundation.Date
import class Foundation.JSONDecoder
import class Foundation.JSONEncoder

private extension String {

    func decodedStringArray() throws -> [String] {
        try JSONDecoder().decode([String].self, from: Data(utf8))
    }
}

private extension Array where Element == String {

    func encodedJSONString() throws -> String {
        let data = try JSONEncoder().encode(self)
        guard let string = String(data: data, encoding: .utf8) else {
            throw RepositoryError(
                reason: .unknown,
                logMessage: "Failed to encode string array as JSON.",
                userFriendlyMessage: "Failed to save blog post associations."
            )
        }
        return string
    }
}

extension PostTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.title = try row.decode(column: "title", as: String.self)
        self.excerpt = try row.decode(column: "excerpt", as: String.self)
        self.content = try row.decode(column: "content", as: String.self)
        self.imageAssetId = try row.decode(
            column: "image_asset_id",
            as: String?.self
        )
        self.authorIds =
            try row.decode(column: "author_ids", as: String.self)
            .decodedStringArray()
        self.tagIds =
            try row.decode(column: "tag_ids", as: String.self)
            .decodedStringArray()
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct PostTable {

    struct Row {

        struct Create {
            let id: String
            let title: String
            let excerpt: String
            let content: String
            let imageAssetId: String?
            let authorIds: [String]
            let tagIds: [String]
        }

        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let authorIds: [String]
        let tagIds: [String]
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        let authorIds = try row.authorIds.encodedJSONString()
        let tagIds = try row.tagIds.encodedJSONString()
        return try await connection.run(
            query: #"""
                INSERT INTO blog_post (
                    id,
                    title,
                    excerpt,
                    content,
                    image_asset_id,
                    author_ids,
                    tag_ids,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.title),
                    \#(row.excerpt),
                    \#(row.content),
                    \#(row.imageAssetId),
                    \#(authorIds),
                    \#(tagIds),
                    NOW(),
                    NOW()
                )
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func list(
        search: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM blog_post
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(title) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(excerpt) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(content) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                )
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit)
                OFFSET \#(offset);
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func count(
        search: String?
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM blog_post
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(title) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(excerpt) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(content) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                );
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return 0
            }
            return try row.decode(column: "count", as: Int.self)
        }
    }

    func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM blog_post
                WHERE id=\#(id)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func update(
        id: String,
        row: Row
    ) async throws -> Row {
        let authorIds = try row.authorIds.encodedJSONString()
        let tagIds = try row.tagIds.encodedJSONString()
        return try await connection.run(
            query: #"""
                UPDATE blog_post
                SET
                    title=\#(row.title),
                    excerpt=\#(row.excerpt),
                    content=\#(row.content),
                    image_asset_id=\#(row.imageAssetId),
                    author_ids=\#(authorIds),
                    tag_ids=\#(tagIds),
                    updated_at=NOW()
                WHERE id=\#(id)
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func removeAuthorReference(
        id: String
    ) async throws {
        try await connection.run(
            query: #"""
                UPDATE blog_post
                SET
                    author_ids = COALESCE(
                        (
                            SELECT jsonb_agg(value)
                            FROM jsonb_array_elements_text(
                                blog_post.author_ids::jsonb
                            ) AS value
                            WHERE value <> \#(id)
                        ),
                        '[]'::jsonb
                    )::text,
                    updated_at = NOW()
                WHERE blog_post.author_ids::jsonb ? \#(id);
                """#
        ) { _ in }
    }

    func removeTagReference(
        id: String
    ) async throws {
        try await connection.run(
            query: #"""
                UPDATE blog_post
                SET
                    tag_ids = COALESCE(
                        (
                            SELECT jsonb_agg(value)
                            FROM jsonb_array_elements_text(
                                blog_post.tag_ids::jsonb
                            ) AS value
                            WHERE value <> \#(id)
                        ),
                        '[]'::jsonb
                    )::text,
                    updated_at = NOW()
                WHERE blog_post.tag_ids::jsonb ? \#(id);
                """#
        ) { _ in }
    }

    func delete(
        id: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM blog_post WHERE id=\#(id) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
