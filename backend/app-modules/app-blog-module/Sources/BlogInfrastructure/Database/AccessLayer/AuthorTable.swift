import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension AuthorTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.key = try row.decode(column: "key", as: String.self)
        self.name = try row.decode(column: "name", as: String.self)
        self.excerpt = try row.decode(column: "excerpt", as: String.self)
        self.content = try row.decode(column: "content", as: String.self)
        self.profileImageAssetId = try row.decode(
            column: "profile_image_asset_id",
            as: String?.self
        )
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct AuthorTable {

    struct Row {

        struct Create {
            let id: String
            let name: String
            let excerpt: String
            let content: String
            let profileImageAssetId: String?
        }

        let id: String
        let key: String
        let name: String
        let excerpt: String
        let content: String
        let profileImageAssetId: String?
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO blog_author (
                    id,
                    key,
                    name,
                    notes,
                    excerpt,
                    content,
                    profile_image_asset_id,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.id),
                    \#(row.name),
                    \#(row.content),
                    \#(row.excerpt),
                    \#(row.content),
                    \#(row.profileImageAssetId),
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
                FROM blog_author
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
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
                FROM blog_author
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
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
                FROM blog_author
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
        try await connection.run(
            query: #"""
                UPDATE blog_author
                SET
                    name=\#(row.name),
                    notes=\#(row.content),
                    excerpt=\#(row.excerpt),
                    content=\#(row.content),
                    profile_image_asset_id=\#(row.profileImageAssetId),
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

    func delete(
        id: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM blog_author WHERE id=\#(id) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
