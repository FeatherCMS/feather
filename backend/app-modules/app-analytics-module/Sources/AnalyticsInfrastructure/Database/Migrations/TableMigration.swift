import Infrastructure
import FeatherDatabase

public struct TableMigration: DatabaseMigration {

    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let queries: [DatabaseQuery] = [
            #"""
            CREATE TABLE IF NOT EXISTS analytics_log (
                id TEXT PRIMARY KEY,
                account_id TEXT NULL,
                source TEXT NOT NULL DEFAULT 'backend_api',
                method TEXT NOT NULL,
                url TEXT NOT NULL,
                headers TEXT NOT NULL,
                ip TEXT NULL,
                path TEXT NOT NULL,
                referer TEXT NULL,
                origin TEXT NULL,
                accept_language TEXT NULL,
                user_agent TEXT NULL,
                language TEXT NULL,
                region TEXT NULL,
                os_name TEXT NULL,
                os_version TEXT NULL,
                browser_name TEXT NULL,
                browser_version TEXT NULL,
                engine_name TEXT NULL,
                engine_version TEXT NULL,
                device_vendor TEXT NULL,
                device_type TEXT NULL,
                device_model TEXT NULL,
                cpu TEXT NULL,
                response_code INT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL,
                updated_at TIMESTAMPTZ NOT NULL
            );
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS analytics_log_created_at_idx
                ON analytics_log (created_at DESC);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS analytics_log_path_idx
                ON analytics_log (path);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS analytics_log_account_id_idx
                ON analytics_log (account_id);
            """#,
            #"""
            CREATE INDEX IF NOT EXISTS analytics_log_source_idx
                ON analytics_log (source);
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
