import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure
import MediaModule

import struct Foundation.Date

extension Asset.File.Table.Row {
    init(from row: any DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        storageObjectId = try row.decode(
            column: "storage_object_id",
            as: String.self
        )
        folderId = try row.decode(column: "folder_id", as: String?.self)
        name = try row.decode(column: "name", as: String.self)
        slug = try row.decode(column: "slug", as: String.self)
        slugPath = try row.decode(column: "slug_path", as: String.self)
        `extension` = try row.decode(column: "extension", as: String.self)
        contentType = try row.decode(column: "content_type", as: String.self)
        sizeBytes = try row.decode(column: "size_bytes", as: Int64.self)
        status = try row.decode(column: "status", as: String.self)
        title = try row.decode(column: "title", as: String?.self)
        altText = try row.decode(column: "alt_text", as: String?.self)
        createdAt = try row.decode(column: "created_at", as: Date.self)
        updatedAt = try row.decode(column: "updated_at", as: Date.self)
        deletedAt = try row.decode(column: "deleted_at", as: Date?.self)
    }
}

extension Asset.File {
    struct Table: DatabaseTable {
        static let name = "media_asset_node_file"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let assetNodeId = DatabaseTableColumn<String>(name: "asset_node_id")
            let storageObjectId = DatabaseTableColumn<String>(name: "storage_object_id")
            let status = DatabaseTableColumn<String>(name: "status")
            let title = DatabaseTableColumn<String?>(name: "title")
            let altText = DatabaseTableColumn<String?>(name: "alt_text")
        }
        struct Row {
            struct Create {
                let id: String
                let folderId: String?
                let name: String
                let slug: String
                let slugPath: String
                let storageObjectId: String
                let `extension`: String
                let contentType: String
                let sizeBytes: Int64
                let status: String
                let title: String?
                let altText: String?
            }

            let id: String
            let folderId: String?
            let name: String
            let slug: String
            let slugPath: String
            let storageObjectId: String
            let `extension`: String
            let contentType: String
            let sizeBytes: Int64
            let status: String
            let title: String?
            let altText: String?
            let createdAt: Date
            let updatedAt: Date
            let deletedAt: Date?
        }

        let connection: any DatabaseConnection
        let context: DatabaseTransactionContext

        func create(row: Row.Create) async throws -> Row {
            _ = try await Asset.Node.Table(connection: connection, context: context)
                .create(
                    row: .init(
                        id: row.id,
                        parentId: row.folderId,
                        name: row.name,
                        slug: row.slug,
                        slugPath: row.slugPath
                    )
                )
            try await DatabaseAccessLayer<Self>(context: context).insert(
                Insert(
                    assetNodeId: row.id,
                    storageObjectId: row.storageObjectId,
                    status: row.status,
                    title: row.title,
                    altText: row.altText
                )
            )
            guard let saved = try await find(id: row.id) else {
                throw RepositoryError.notFound
            }
            return saved
        }

        func find(id: String) async throws -> Row? {
            try await connection.run(
                query: #"""
                    \#(unescaped: mediaAssetNodeFileSelectPrefix)
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
                    \#(unescaped: mediaAssetNodeFileSelectPrefix)
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

        func resolve(ids: [String]) async throws -> [Row] {
            guard !ids.isEmpty else { return [] }
            return try await connection.run(
                query: #"""
                    \#(unescaped: mediaAssetNodeFileSelectPrefix)
                    WHERE n.id IN (\#(ids)) AND n.deleted_at IS NULL;
                    """#
            ) { sequence in
                try await sequence.collect().map { try Row(from: $0) }
            }
        }

        func update(row: Row) async throws -> Row {
            _ = try await Asset.Node.Table(connection: connection, context: context)
                .update(
                    row: .init(
                        id: row.id,
                        parentId: row.folderId,
                        name: row.name,
                        slug: row.slug,
                        slugPath: row.slugPath
                    )
                )
            try await DatabaseAccessLayer<Self>(context: context).update(
                Update(status: row.status, title: row.title, altText: row.altText),
                where: \.assetNodeId,
                equals: row.id
            )
            guard let result = try await find(id: row.id) else {
                throw RepositoryError.notFound
            }
            return result
        }

        func updateStatus(id: String, status: String) async throws {
            try await DatabaseAccessLayer<Self>(context: context).update(
                Update(status: status),
                where: \.assetNodeId,
                equals: id
            )
        }

        func delete(ids: [String]) async throws -> [String] {
            guard !ids.isEmpty else { return [] }
            return try await AssetFileDeleteQuery(connection: connection)
                .delete(ids: ids)
        }

        func list(folderIds: [String]) async throws -> [Row] {
            guard !folderIds.isEmpty else { return [] }
            return try await connection.run(
                query: #"""
                    \#(unescaped: mediaAssetNodeFileSelectPrefix)
                    WHERE n.deleted_at IS NULL AND n.parent_id IN (\#(folderIds))
                    ORDER BY n.created_at ASC, n.id ASC;
                    """#
            ) { sequence in
                try await sequence.collect().map { try Row(from: $0) }
            }
        }
    }
    }

    private let mediaAssetNodeFileSelectPrefix = #"""
    SELECT
        n.id,
        n.parent_id AS folder_id,
        n.name,
        n.slug,
        \#(Asset.Node.SlugPath.sql) AS slug_path,
        f.storage_object_id,
        o.extension,
        o.content_type,
        o.size_in_bytes AS size_bytes,
        f.status,
        f.title,
        f.alt_text,
        n.created_at,
        n.updated_at,
        n.deleted_at
    FROM media_asset_node n
    JOIN media_asset_node_file f ON f.asset_node_id = n.id
    JOIN media_storage_object o ON o.id = f.storage_object_id AND o.key = 'original'
    """#

