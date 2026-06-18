import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension PageTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.title = try row.decode(column: "title", as: String.self)
        self.excerpt = try row.decode(column: "excerpt", as: String.self)
        self.content = try row.decode(column: "content", as: String.self)
        self.imageAssetId = try row.decode(
            column: "image_asset_id",
            as: String?.self
        )
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct PageTable {

    struct Row {

        struct Create {
            let id: String
            let title: String
            let excerpt: String
            let content: String
            let imageAssetId: String?
        }

        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO web_page (
                    id,
                    title,
                    excerpt,
                    content,
                    image_asset_id,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.title),
                    \#(row.excerpt),
                    \#(row.content),
                    \#(row.imageAssetId),
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
                FROM web_page
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
                FROM web_page
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
                FROM web_page
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
                UPDATE web_page
                SET
                    title=\#(row.title),
                    excerpt=\#(row.excerpt),
                    content=\#(row.content),
                    image_asset_id=\#(row.imageAssetId),
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
                DELETE FROM web_page WHERE id=\#(id) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
