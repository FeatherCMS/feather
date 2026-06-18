import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension MenuItemTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.menuId = try row.decode(column: "menu_id", as: String.self)
        self.label = try row.decode(column: "label", as: String.self)
        self.url = try row.decode(column: "url", as: String.self)
        self.priority = try row.decode(column: "priority", as: Int.self)
        self.isBlank = try row.decode(column: "is_blank", as: Bool.self)
        self.permission = try row.decode(column: "permission", as: String.self)
        self.notes = try row.decode(column: "notes", as: String.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct MenuItemTable {

    struct Row {

        struct Create {
            let id: String
            let menuId: String
            let label: String
            let url: String
            let priority: Int
            let isBlank: Bool
            let permission: String
            let notes: String
        }

        let id: String
        let menuId: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let notes: String
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO web_menu_item (
                    id,
                    menu_id,
                    label,
                    url,
                    priority,
                    is_blank,
                    permission,
                    notes,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.menuId),
                    \#(row.label),
                    \#(row.url),
                    \#(row.priority),
                    \#(row.isBlank),
                    \#(row.permission),
                    \#(row.notes),
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
        menuId: String,
        search: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM web_menu_item
                WHERE menu_id=\#(menuId)
                  AND (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(label) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(url) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR CAST(priority AS TEXT) LIKE '%' || \#(search ?? "") || '%'
                    OR LOWER(permission) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(notes) LIKE '%' || LOWER(\#(search ?? "")) || '%'
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
        menuId: String,
        search: String?
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM web_menu_item
                WHERE menu_id=\#(menuId)
                  AND (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(label) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(url) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR CAST(priority AS TEXT) LIKE '%' || \#(search ?? "") || '%'
                    OR LOWER(permission) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(notes) LIKE '%' || LOWER(\#(search ?? "")) || '%'
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
                FROM web_menu_item
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
                UPDATE web_menu_item
                SET
                    menu_id=\#(row.menuId),
                    label=\#(row.label),
                    url=\#(row.url),
                    priority=\#(row.priority),
                    is_blank=\#(row.isBlank),
                    permission=\#(row.permission),
                    notes=\#(row.notes),
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
                DELETE FROM web_menu_item WHERE id=\#(id) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
