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
            // MARK: - media folder
            #"""
            CREATE TABLE IF NOT EXISTS media_folder (
                id TEXT PRIMARY KEY,
                parent_id TEXT REFERENCES media_folder(id) ON DELETE CASCADE,
                name TEXT NOT NULL,
                path TEXT NOT NULL UNIQUE,
                asset_count INTEGER NOT NULL DEFAULT 0,
                total_size_bytes BIGINT NOT NULL DEFAULT 0,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                deleted_at TIMESTAMPTZ
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_folder_parent_id_idx
            ON media_folder (parent_id);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_folder_path_idx
            ON media_folder (path);
            """#,

            // MARK: - media asset
            #"""
            CREATE TABLE IF NOT EXISTS media_asset (
                id TEXT PRIMARY KEY,
                folder_id TEXT REFERENCES media_folder(id) ON DELETE SET NULL,
                storage_key TEXT NOT NULL UNIQUE,
                base_name TEXT NOT NULL,
                type TEXT NOT NULL,
                size_bytes BIGINT NOT NULL,
                status TEXT NOT NULL,
                title TEXT,
                alt_text TEXT,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                deleted_at TIMESTAMPTZ
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_status_deleted_at_idx
            ON media_asset (status, deleted_at);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_folder_id_idx
            ON media_asset (folder_id);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS media_asset_type_idx
            ON media_asset (type);
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
                FOREIGN KEY(asset_id) REFERENCES media_asset(id) ON DELETE CASCADE,
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
