import ContactModule
public import FeatherDBAL
public import FeatherDatabase
public import FeatherInfrastructure

public struct TableMigration: DatabaseMigration {
    public let connection: any DatabaseConnection
    public let platform: any DatabasePlatform

    public init(
        connection: any DatabaseConnection,
        platform: any DatabasePlatform
    ) {
        self.connection = connection
        self.platform = platform
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let schemas = [
            Form.Table.tableCreationSchema,
            SubmissionMail.Table.tableCreationSchema,
            FormField.Table.tableCreationSchema,
            Submission.Table.tableCreationSchema,
            FormFieldAssignment.Table.tableCreationSchema,
        ]

        for schema in schemas {
            let queryBuilder = DatabaseQueryCreate(
                schema: schema,
                using: platform
            )
            for query in queryBuilder.build() {
                try await connection.run(query: query) { _ in }
            }
        }
        try await connection.run(
            query:
                #"ALTER TABLE contact_form ADD COLUMN IF NOT EXISTS submit_label TEXT NOT NULL DEFAULT 'Submit';"#
        ) { _ in }
        try await FormField.AccessLayer.applyCheckConstraints(on: connection)
        try await Submission.Table.applyStatusConstraint(on: connection)
    }
}
