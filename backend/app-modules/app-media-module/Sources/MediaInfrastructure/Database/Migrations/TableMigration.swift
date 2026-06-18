import FeatherDatabase
import Infrastructure

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
            #"""
            INSERT INTO media_processor (
                id, name, match_extensions, command_template, is_required, is_active, created_at, updated_at
            ) VALUES
                ('media_processor_image_preview', 'image_preview', 'png,jpg,jpeg', 'convert {input.fullname} -resize 256x256^ -gravity center -extent 256x256 {output.fullname}', TRUE, TRUE, NOW(), NOW()),
                ('media_processor_pdf_preview', 'pdf_preview', 'pdf', 'gs -dSAFER -dBATCH -dNOPAUSE -dNOPROMPT -sDEVICE=pngalpha -r300 -dFirstPage=1 -dLastPage=1 -dUseCropBox -dFIXEDMEDIA -dPDFFitPage -g256x256 -sOutputFile="{output.dirname}/{output.basename}.png" "{input.fullname}"', TRUE, TRUE, NOW(), NOW()),
                ('media_processor_video_preview', 'video_preview', 'mp4,mov,avi', 'ffmpeg -y -ss 00:00:01 -i "{input.fullname}" -frames:v 1 -vf "scale=256:256:force_original_aspect_ratio=decrease,pad=256:256:(ow-iw)/2:(oh-ih)/2" "{output.dirname}/{output.basename}.png"', TRUE, TRUE, NOW(), NOW())
            ON CONFLICT (id) DO UPDATE SET
                name = EXCLUDED.name,
                match_extensions = EXCLUDED.match_extensions,
                command_template = EXCLUDED.command_template,
                is_required = EXCLUDED.is_required,
                is_active = EXCLUDED.is_active,
                updated_at = NOW();
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
