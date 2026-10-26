import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure
import MediaModule

import struct Foundation.Date

extension Asset.Folder.Table.Row {
    init(from row: any DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        parentId = try row.decode(column: "parent_id", as: String?.self)
        name = try row.decode(column: "name", as: String.self)
        slug = try row.decode(column: "slug", as: String.self)
        slugPath = try row.decode(column: "slug_path", as: String.self)
        assetCount = try row.decode(column: "asset_count", as: Int.self)
        totalSizeBytes = try row.decode(
            column: "total_size_bytes",
            as: Int64.self
        )
        createdAt = try row.decode(column: "created_at", as: Date.self)
        updatedAt = try row.decode(column: "updated_at", as: Date.self)
        deletedAt = try row.decode(column: "deleted_at", as: Date?.self)
    }
}

extension Asset.Folder {
    struct Table: DatabaseTable {
        static let name = "media_asset_node_folder"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let assetNodeId = DatabaseTableColumn<String>(name: "asset_node_id")
            let assetCount = DatabaseTableColumn<Int>(name: "asset_count")
            let totalSizeBytes = DatabaseTableColumn<Int64>(
                name: "total_size_bytes"
            )
        }
        struct Row {
            struct Create {
                let id: String
                let parentId: String?
                let name: String
                let slug: String
                let slugPath: String
                let assetCount: Int
                let totalSizeBytes: Int64
            }

            let id: String
            let parentId: String?
            let name: String
            let slug: String
            let slugPath: String
            let assetCount: Int
            let totalSizeBytes: Int64
            let createdAt: Date
            let updatedAt: Date
            let deletedAt: Date?
        }

        let connection: any DatabaseConnection
        let context: DatabaseTransactionContext

        func create(row: Row.Create) async throws -> Row {
            _ = try await Asset.Node
                .Table(connection: connection, context: context)
                .create(
                    row: .init(
                        id: row.id,
                        parentId: row.parentId,
                        name: row.name,
                        slug: row.slug,
                        slugPath: row.slugPath
                    )
                )
            try await DatabaseAccessLayer<Self>(context: context)
                .insert(
                    Insert(
                        assetNodeId: row.id,
                        assetCount: row.assetCount,
                        totalSizeBytes: Int(row.totalSizeBytes)
                    )
                )
            guard let result = try await find(id: row.id) else {
                throw RepositoryError.notFound
            }
            return result
        }

        func update(row: Row) async throws -> Row {
            _ = try await Asset.Node
                .Table(connection: connection, context: context)
                .update(
                    row: .init(
                        id: row.id,
                        parentId: row.parentId,
                        name: row.name,
                        slug: row.slug,
                        slugPath: row.slugPath
                    )
                )
            try await DatabaseAccessLayer<Self>(context: context)
                .update(
                    Update(
                        assetCount: row.assetCount,
                        totalSizeBytes: Int(row.totalSizeBytes)
                    ),
                    where: \.assetNodeId,
                    equals: row.id
                )
            guard let result = try await find(id: row.id) else {
                throw RepositoryError.notFound
            }
            return result
        }

        func find(id: String) async throws -> Row? {
            try await connection.run(
                query: #"""
                    SELECT n.id, n.parent_id, n.name, n.slug,
                           \#(unescaped: Asset.Node.SlugPath.sql) AS slug_path,
                           (
                               SELECT COUNT(*)::integer
                               FROM media_asset_node child
                               WHERE child.parent_id = n.id
                                 AND child.deleted_at IS NULL
                           ) AS asset_count,
                           f.total_size_bytes,
                           n.created_at, n.updated_at, n.deleted_at
                    FROM media_asset_node n
                    JOIN media_asset_node_folder f ON f.asset_node_id = n.id
                    WHERE n.id = \#(id) AND n.deleted_at IS NULL
                    LIMIT 1;
                    """#
            ) { sequence in
                guard let row = try await sequence.collect().first else {
                    return nil
                }
                return try Row(from: row)
            }
        }

        func find(slugPath: String) async throws -> Row? {
            let absoluteSlug = Asset.Node.SlugPath.parent(of: slugPath)
            let slug = Asset.Node.SlugPath.slug(of: slugPath)
            return try await connection.run(
                query: #"""
                    SELECT n.id, n.parent_id, n.name, n.slug,
                           \#(unescaped: Asset.Node.SlugPath.sql) AS slug_path,
                           (
                               SELECT COUNT(*)::integer
                               FROM media_asset_node child
                               WHERE child.parent_id = n.id
                                 AND child.deleted_at IS NULL
                           ) AS asset_count,
                           f.total_size_bytes,
                           n.created_at, n.updated_at, n.deleted_at
                    FROM media_asset_node n
                    JOIN media_asset_node_folder f ON f.asset_node_id = n.id
                    WHERE n.absolute_slug = \#(absoluteSlug)
                      AND n.slug = \#(slug)
                      AND n.deleted_at IS NULL
                    LIMIT 1;
                    """#
            ) { sequence in
                guard let row = try await sequence.collect().first else {
                    return nil
                }
                return try Row(from: row)
            }
        }

        func list(parentId: String?) async throws -> [Row] {
            try await connection.run(
                query: #"""
                    SELECT n.id, n.parent_id, n.name, n.slug,
                           \#(unescaped: Asset.Node.SlugPath.sql) AS slug_path,
                           (
                               SELECT COUNT(*)::integer
                               FROM media_asset_node child
                               WHERE child.parent_id = n.id
                                 AND child.deleted_at IS NULL
                           ) AS asset_count,
                           f.total_size_bytes,
                           n.created_at, n.updated_at, n.deleted_at
                    FROM media_asset_node n
                    JOIN media_asset_node_folder f ON f.asset_node_id = n.id
                    WHERE n.deleted_at IS NULL
                      AND ((\#(parentId == nil) AND n.parent_id IS NULL) OR n.parent_id = \#(parentId))
                    ORDER BY LOWER(n.name) ASC, n.id ASC;
                    """#
            ) { sequence in
                try await sequence.collect().map { try Row(from: $0) }
            }
        }

        func search(
            parentId: String?,
            orderBy: String,
            limit: Int,
            offset: Int
        ) async throws -> [Row] {
            try await connection.run(
                query: #"""
                    SELECT n.id, n.parent_id, n.name, n.slug,
                           \#(unescaped: Asset.Node.SlugPath.sql) AS slug_path,
                           (
                               SELECT COUNT(*)::integer
                               FROM media_asset_node child
                               WHERE child.parent_id = n.id
                                 AND child.deleted_at IS NULL
                           ) AS asset_count,
                           f.total_size_bytes,
                           n.created_at, n.updated_at, n.deleted_at
                    FROM media_asset_node n
                    JOIN media_asset_node_folder f ON f.asset_node_id = n.id
                    WHERE n.deleted_at IS NULL
                      AND ((\#(parentId == nil) AND n.parent_id IS NULL) OR n.parent_id = \#(parentId))
                    ORDER BY \#(unescaped: orderBy)
                    LIMIT \#(limit) OFFSET \#(offset);
                    """#
            ) { sequence in
                try await sequence.collect().map { try Row(from: $0) }
            }
        }

        func count(parentId: String?) async throws -> Int {
            try await connection.run(
                query: #"""
                    SELECT COUNT(*) AS count
                    FROM media_asset_node n
                    JOIN media_asset_node_folder f ON f.asset_node_id = n.id
                    WHERE n.deleted_at IS NULL
                      AND ((\#(parentId == nil) AND n.parent_id IS NULL) OR n.parent_id = \#(parentId));
                    """#
            ) { sequence in
                guard let row = try await sequence.collect().first else {
                    return 0
                }
                return try row.decode(column: "count", as: Int.self)
            }
        }

        func listDescendants(slugPath: String) async throws -> [Row] {
            try await connection.run(
                query: #"""
                    SELECT n.id, n.parent_id, n.name, n.slug,
                           \#(unescaped: Asset.Node.SlugPath.sql) AS slug_path,
                           (
                               SELECT COUNT(*)::integer
                               FROM media_asset_node child
                               WHERE child.parent_id = n.id
                                 AND child.deleted_at IS NULL
                           ) AS asset_count,
                           f.total_size_bytes,
                           n.created_at, n.updated_at, n.deleted_at
                    FROM media_asset_node n
                    JOIN media_asset_node_folder f ON f.asset_node_id = n.id
                    WHERE n.deleted_at IS NULL
                      AND (\#(unescaped: Asset.Node.SlugPath.sql) = \#(slugPath)
                        OR n.absolute_slug = \#(slugPath)
                        OR n.absolute_slug LIKE \#(slugPath + "/%"))
                    ORDER BY LENGTH(\#(unescaped: Asset.Node.SlugPath.sql)) ASC, LOWER(n.name) ASC, n.id ASC;
                    """#
            ) { sequence in
                try await sequence.collect().map { try Row(from: $0) }
            }
        }

        func delete(ids: [String]) async throws -> [String] {
            guard !ids.isEmpty else { return [] }
            return try await DeleteQuery(connection: connection)
                .delete(ids: ids)
        }
    }
}
