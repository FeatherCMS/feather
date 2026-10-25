import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure
import MediaModule

import struct Foundation.Date

extension Asset.Node {
    struct Table: DatabaseTable {
        static let name = "media_asset_node"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let parentId = DatabaseTableColumn<String?>(name: "parent_id")
            let name = DatabaseTableColumn<String>(name: "name")
            let slug = DatabaseTableColumn<String>(name: "slug")
            let absoluteSlug = DatabaseTableColumn<String>(name: "absolute_slug")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
            let deletedAt = DatabaseTableColumn<Date?>(name: "deleted_at")
        }
        struct Row {
            struct Create {
                let id: String
                let parentId: String?
                let name: String
                let slug: String
                let slugPath: String
            }

            struct Update {
                let id: String
                let parentId: String?
                let name: String
                let slug: String
                let slugPath: String
            }

            let id: String
            let parentId: String?
            let name: String
            let slug: String
            let slugPath: String
            let createdAt: Date
            let updatedAt: Date
            let deletedAt: Date?

            init(
                id: String,
                parentId: String?,
                name: String,
                slug: String,
                slugPath: String,
                createdAt: Date,
                updatedAt: Date,
                deletedAt: Date?
            ) {
                self.id = id
                self.parentId = parentId
                self.name = name
                self.slug = slug
                self.slugPath = slugPath
                self.createdAt = createdAt
                self.updatedAt = updatedAt
                self.deletedAt = deletedAt
            }

            init(from row: any DatabaseRow) throws {
                id = try row.decode(column: "id", as: String.self)
                parentId = try row.decode(column: "parent_id", as: String?.self)
                name = try row.decode(column: "name", as: String.self)
                slug = try row.decode(column: "slug", as: String.self)
                slugPath = try row.decode(column: "slug_path", as: String.self)
                createdAt = try row.decode(column: "created_at", as: Date.self)
                updatedAt = try row.decode(column: "updated_at", as: Date.self)
                deletedAt = try row.decode(column: "deleted_at", as: Date?.self)
            }
        }

        struct SearchRow {
            let kind: String
            let id: String
            let parentId: String?
            let name: String
            let slug: String
            let slugPath: String
            let `extension`: String?
            let contentType: String?
            let sizeBytes: Int64?
            let status: String?
            let title: String?
            let altText: String?
            let assetCount: Int?
            let totalSizeBytes: Int64?
            let createdAt: Date
            let updatedAt: Date

            init(from row: any DatabaseRow) throws {
                kind = try row.decode(column: "kind", as: String.self)
                id = try row.decode(column: "id", as: String.self)
                parentId = try row.decode(column: "parent_id", as: String?.self)
                name = try row.decode(column: "name", as: String.self)
                slug = try row.decode(column: "slug", as: String.self)
                slugPath = try row.decode(column: "slug_path", as: String.self)
                `extension` = try row.decode(
                    column: "extension",
                    as: String?.self
                )
                contentType = try row.decode(
                    column: "content_type",
                    as: String?.self
                )
                sizeBytes = try row.decode(
                    column: "size_bytes",
                    as: Int64?.self
                )
                status = try row.decode(column: "status", as: String?.self)
                title = try row.decode(column: "title", as: String?.self)
                altText = try row.decode(column: "alt_text", as: String?.self)
                assetCount = try row.decode(
                    column: "asset_count",
                    as: Int?.self
                )
                totalSizeBytes = try row.decode(
                    column: "total_size_bytes",
                    as: Int64?.self
                )
                createdAt = try row.decode(column: "created_at", as: Date.self)
                updatedAt = try row.decode(column: "updated_at", as: Date.self)
            }
        }

        let connection: any DatabaseConnection
        let context: DatabaseTransactionContext

        func create(row: Row.Create) async throws -> Row {
            try await DatabaseAccessLayer<Self>(context: context).insert(
                Insert(
                    id: row.id,
                    parentId: row.parentId,
                    name: row.name,
                    slug: row.slug,
                    absoluteSlug: SlugPath.parent(of: row.slugPath)
                )
            )
            guard let result = try await find(id: row.id) else {
                throw RepositoryError.notFound
            }
            return result
        }

        func update(row: Row.Update) async throws -> Row {
            guard let old = try await find(id: row.id) else {
                throw RepositoryError.notFound
            }
            try await DatabaseAccessLayer<Self>(context: context).update(
                Update(
                    parentId: row.parentId,
                    name: row.name,
                    slug: row.slug,
                    absoluteSlug: SlugPath.parent(of: row.slugPath)
                ),
                where: \.id,
                equals: row.id
            )
            if old.slugPath != row.slugPath {
                try await SubtreeUpdateQuery(connection: connection)
                    .update(
                        oldSlugPath: old.slugPath,
                        newSlugPath: row.slugPath
                    )
            }
            guard let result = try await find(id: row.id) else {
                throw RepositoryError.notFound
            }
            return result
        }

        func find(id: String) async throws -> Row? {
            try await DatabaseAccessLayer<Self>(context: context)
                .selectFirst(as: Detail.self) {
                    $0.where(\.id, equals: id).isNull(\.deletedAt)
                }
                .map(\.row)
        }

        func find(slugPath: String) async throws -> Row? {
            let absoluteSlug = SlugPath.parent(of: slugPath)
            let slug = SlugPath.slug(of: slugPath)
            return try await connection.run(
                query: #"""
                    SELECT id, parent_id, name, slug,
                           \#(unescaped: Asset.Node.SlugPath.sql) AS slug_path,
                           created_at, updated_at, deleted_at
                    FROM media_asset_node n
                    WHERE absolute_slug = \#(absoluteSlug)
                      AND slug = \#(slug)
                      AND deleted_at IS NULL
                    LIMIT 1;
                    """#
            ) { sequence in
                guard let row = try await sequence.collect().first else {
                    return nil
                }
                return try Row(from: row)
            }
        }

        func search(
            parentId: String?,
            search: String?,
            orderBy: String,
            limit: Int,
            offset: Int
        ) async throws -> [SearchRow] {
            try await connection.run(
                query: #"""
                    WITH entries AS (
                        SELECT 'folder' AS kind, 0 AS kind_rank, n.id, n.parent_id, n.name, n.slug,
                               \#(unescaped: Asset.Node.SlugPath.sql) AS slug_path,
                               NULL::text AS extension, NULL::text AS content_type,
                               NULL::bigint AS size_bytes, NULL::text AS status, NULL::text AS title, NULL::text AS alt_text,
                               (
                                   SELECT COUNT(*)::integer
                                   FROM media_asset_node child
                                   WHERE child.parent_id = n.id
                                     AND child.deleted_at IS NULL
                               ) AS asset_count,
                               f.total_size_bytes, n.created_at, n.updated_at
                        FROM media_asset_node n
                        JOIN media_asset_node_folder f ON f.asset_node_id = n.id
                        WHERE n.deleted_at IS NULL
                          AND ((\#(parentId == nil) AND n.parent_id IS NULL) OR n.parent_id = \#(parentId))
                          AND (\#(search == nil) OR LOWER(n.name) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(\#(unescaped: Asset.Node.SlugPath.sql)) LIKE '%' || LOWER(\#(search ?? "")) || '%')
                        UNION ALL
                        SELECT 'file' AS kind, 1 AS kind_rank, n.id, n.parent_id, n.name, n.slug,
                               \#(unescaped: Asset.Node.SlugPath.sql) AS slug_path,
                               o.extension, o.content_type, o.size_in_bytes AS size_bytes, f.status, f.title, f.alt_text,
                               NULL::integer AS asset_count, NULL::bigint AS total_size_bytes, n.created_at, n.updated_at
                        FROM media_asset_node n
                        JOIN media_asset_node_file f ON f.asset_node_id = n.id
                        JOIN media_storage_object o ON o.id = f.storage_object_id AND o.key = 'original'
                        WHERE n.deleted_at IS NULL
                          AND ((\#(parentId == nil) AND n.parent_id IS NULL) OR n.parent_id = \#(parentId))
                          AND (\#(search == nil) OR LOWER(n.id) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(n.name) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(\#(unescaped: Asset.Node.SlugPath.sql)) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(o.extension) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(f.status) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(COALESCE(f.title, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(COALESCE(f.alt_text, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%')
                    )
                    SELECT * FROM entries
                    ORDER BY \#(unescaped: orderBy)
                    LIMIT \#(limit) OFFSET \#(offset);
                    """#
            ) { sequence in
                try await sequence.collect().map { try SearchRow(from: $0) }
            }
        }

        func count(parentId: String?, search: String?) async throws -> Int {
            try await connection.run(
                query: #"""
                    SELECT COUNT(*) AS count
                    FROM media_asset_node n
                    WHERE n.deleted_at IS NULL
                      AND ((\#(parentId == nil) AND n.parent_id IS NULL) OR n.parent_id = \#(parentId))
                      AND (\#(search == nil) OR LOWER(n.name) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(\#(unescaped: Asset.Node.SlugPath.sql)) LIKE '%' || LOWER(\#(search ?? "")) || '%');
                    """#
            ) { sequence in
                guard let row = try await sequence.collect().first else {
                    return 0
                }
                return try row.decode(column: "count", as: Int.self)
            }
        }
    }
    }

