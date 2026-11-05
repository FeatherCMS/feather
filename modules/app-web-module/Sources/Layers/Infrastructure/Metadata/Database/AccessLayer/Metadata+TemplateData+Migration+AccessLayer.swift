import FeatherDBAL
import FeatherDatabase
import WebModule

extension Metadata {
    enum TemplateDataMigrationAccessLayer {
        static func addColumn(
            connection: any DatabaseConnection
        ) async throws {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 82,
                interpolationCount: 0
            )
            sql.appendLiteral(
                "ALTER TABLE web_metadata ADD COLUMN IF NOT EXISTS template_data TEXT"
            )
            let query = DatabaseQuery(
                stringInterpolation: sql
            )
            try await connection.run(query: query) { _ in }
        }
    }
}
