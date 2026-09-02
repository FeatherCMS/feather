//
//  MenuItemTable.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure
import WebDomain

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
        let authentication = try row.decode(
            column: "authentication",
            as: String.self
        )
        self.authentication =
            MenuItemAuthentication(rawValue: authentication) ?? .any
        self.notes = try row.decode(column: "notes", as: String?.self)
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
            let authentication: MenuItemAuthentication
            let notes: String?
        }

        let id: String
        let menuId: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let authentication: MenuItemAuthentication
        let notes: String?
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
                    authentication,
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
                    \#(row.authentication.rawValue),
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
                    authentication=\#(row.authentication.rawValue),
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

    func move(
        id: String,
        menuId: String,
        beforeItemID: String?
    ) async throws {
        try await connection.run(
            query: #"""
                WITH locked AS (
                    SELECT id, priority
                    FROM web_menu_item
                    WHERE menu_id=\#(menuId)
                    FOR UPDATE
                ), ordered AS (
                    SELECT
                        id,
                        CAST(
                            ROW_NUMBER() OVER (ORDER BY priority, id) - 1
                            AS INTEGER
                        ) AS position
                    FROM locked
                ), moved AS (
                    SELECT id
                    FROM ordered
                    WHERE id=\#(id)
                ), remaining AS (
                    SELECT
                        id,
                        CAST(
                            ROW_NUMBER() OVER (ORDER BY position) - 1
                            AS INTEGER
                        ) AS position
                    FROM ordered
                    WHERE id<>\#(id)
                ), target AS (
                    SELECT CASE
                        WHEN \#(beforeItemID == nil || beforeItemID?.isEmpty == true)
                        THEN CAST((SELECT COUNT(*) FROM remaining) AS INTEGER)
                        ELSE (
                            SELECT position
                            FROM remaining
                            WHERE id=\#(beforeItemID ?? "")
                        )
                    END AS position
                ), final_order AS (
                    SELECT
                        remaining.id,
                        remaining.position + CASE
                            WHEN remaining.position >= target.position THEN 1
                            ELSE 0
                        END AS position
                    FROM remaining
                    CROSS JOIN target
                    UNION ALL
                    SELECT
                        moved.id,
                        target.position AS position
                    FROM moved
                    CROSS JOIN target
                ), reordered AS (
                    SELECT
                        id,
                        CAST(
                            ROW_NUMBER() OVER (ORDER BY position, id) - 1
                            AS INTEGER
                        ) AS priority,
                        (SELECT position FROM target) IS NOT NULL
                            AS valid_target
                    FROM final_order
                )
                UPDATE web_menu_item AS item
                SET
                    priority=reordered.priority,
                    updated_at=NOW()
                FROM reordered
                WHERE item.id=reordered.id
                  AND reordered.valid_target
                  AND reordered.priority IS NOT NULL
                RETURNING item.id;
                """#
        ) { sequence in
            guard try await sequence.collect().first != nil else {
                throw RepositoryError.notFound
            }
        }
    }

    func delete(
        ids: [String]
    ) async throws -> [String] {
        guard !ids.isEmpty else { return [] }
        let values =
            ids.map {
                "'\($0.replacingOccurrences(of: "'", with: "''"))'"
            }
            .joined(separator: ", ")
        return try await connection.run(
            query: #"""
                DELETE FROM web_menu_item
                WHERE id IN (\#(unescaped: values))
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect()
                .map {
                    try $0.decode(column: "id", as: String.self)
                }
        }
    }
}
