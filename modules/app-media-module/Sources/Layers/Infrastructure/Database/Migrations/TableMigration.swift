//
//  TableMigration.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure

public struct TableMigration: DatabaseMigration {

    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let queries: [DatabaseQuery] = [
            // The media hierarchy is intentionally rebuilt. The old tables are
            // not compatible with the shared node identity model.
            #"DROP TABLE IF EXISTS media_processor_asset;"#,
            #"DROP TABLE IF EXISTS media_asset_node_file;"#,
            #"DROP TABLE IF EXISTS media_asset_node_folder;"#,
            #"DROP TABLE IF EXISTS media_asset_node;"#,
            #"DROP TABLE IF EXISTS media_asset;"#,
            #"DROP TABLE IF EXISTS media_folder;"#,

            // MARK: - media asset node
            #"""
            CREATE TABLE IF NOT EXISTS media_asset_node (
                id TEXT PRIMARY KEY,
                parent_id TEXT REFERENCES media_asset_node(id) ON DELETE CASCADE,
                kind TEXT NOT NULL CHECK (kind IN ('folder', 'file')),
                name TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                deleted_at TIMESTAMPTZ
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_parent_id_idx
            ON media_asset_node (parent_id);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_kind_deleted_at_idx
            ON media_asset_node (kind, deleted_at);
            """#,

            // MARK: - media asset node folder
            #"""
            CREATE TABLE IF NOT EXISTS media_asset_node_folder (
                node_id TEXT PRIMARY KEY REFERENCES media_asset_node(id) ON DELETE CASCADE,
                path TEXT NOT NULL UNIQUE,
                asset_count INTEGER NOT NULL DEFAULT 0,
                total_size_bytes BIGINT NOT NULL DEFAULT 0
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_folder_path_idx
            ON media_asset_node_folder (path);
            """#,

            // MARK: - media asset node file
            #"""
            CREATE TABLE IF NOT EXISTS media_asset_node_file (
                node_id TEXT PRIMARY KEY REFERENCES media_asset_node(id) ON DELETE CASCADE,
                storage_key TEXT NOT NULL UNIQUE,
                base_name TEXT NOT NULL,
                type TEXT NOT NULL,
                size_bytes BIGINT NOT NULL,
                status TEXT NOT NULL,
                title TEXT,
                alt_text TEXT
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_file_status_idx
            ON media_asset_node_file (status);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_node_file_type_idx
            ON media_asset_node_file (type);
            """#,

            // MARK: - media processor
            #"""
            CREATE TABLE IF NOT EXISTS media_processor (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL UNIQUE,
                match_extensions TEXT NOT NULL,
                command_template TEXT NOT NULL,
                is_required BOOLEAN NOT NULL DEFAULT TRUE,
                is_active BOOLEAN NOT NULL DEFAULT TRUE,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            #"""
            CREATE TABLE IF NOT EXISTS media_processor_asset (
                id TEXT PRIMARY KEY,
                asset_id TEXT NOT NULL,
                processor_id TEXT NOT NULL,
                storage_key TEXT NOT NULL UNIQUE,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                UNIQUE(asset_id, processor_id),
                FOREIGN KEY(asset_id) REFERENCES media_asset_node_file(node_id) ON DELETE CASCADE,
                FOREIGN KEY(processor_id) REFERENCES media_processor(id) ON DELETE CASCADE
            );
            """#,
            #"CREATE INDEX IF NOT EXISTS media_processor_asset_asset_id_idx ON media_processor_asset (asset_id);"#,
            #"CREATE INDEX IF NOT EXISTS media_processor_asset_processor_id_idx ON media_processor_asset (processor_id);"#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
