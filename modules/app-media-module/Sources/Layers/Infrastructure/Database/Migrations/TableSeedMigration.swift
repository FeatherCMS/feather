import FeatherDatabase
import FeatherInfrastructure

public struct TableSeedMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        try await connection.run(
            query: #"""
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
        ) { _ in }
    }
}
