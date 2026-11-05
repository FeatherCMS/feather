import ContactModule
import FeatherDBAL
import FeatherDatabase

extension Submission.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.id.name, type: .string),
                .init(
                    name: columns.formId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.values.name,
                    type: .json,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.itemsSnapshot.name,
                    type: .json,
                    constraints: [.notNull]
                ),
                .init(name: columns.metadata.name, type: .json),
                .init(
                    name: columns.status.name,
                    type: .string,
                    constraints: [.notNull, .default(.value("received"))]
                ),
                .init(
                    name: columns.createdAt.name,
                    type: .timestamp,
                    constraints: [.notNull, .default(.currentTimestamp)]
                ),
                .init(
                    name: columns.updatedAt.name,
                    type: .timestamp,
                    constraints: [.notNull, .default(.currentTimestamp)]
                ),
            ],
            constraints: [
                .primaryKey([.init(name: columns.id.name, type: .string)]),
                .foreignKey(
                    columns: [.init(name: columns.formId.name, type: .string)],
                    referencesTable: Form.Table.name,
                    referencedColumns: [
                        .init(name: Form.Table.columns.id.name, type: .string)
                    ],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(
                    name: "contact_form_submission_form_id_idx",
                    columns: [
                        .init(name: columns.formId.name, type: .string),
                        .init(name: columns.createdAt.name, type: .timestamp),
                    ]
                ),
                .init(
                    name: "contact_form_submission_status_idx",
                    columns: [.init(name: columns.status.name, type: .string)]
                ),
            ]
        )
    }

    static func applyStatusConstraint(
        on connection: any DatabaseConnection
    ) async throws {
        try await connection.run(
            query: #"""
                DO $$ BEGIN
                    IF NOT EXISTS (
                        SELECT 1 FROM pg_constraint
                        WHERE conname = 'contact_form_submission_status_check'
                          AND conrelid = 'contact_form_submission'::regclass
                    ) THEN
                        ALTER TABLE contact_form_submission
                        ADD CONSTRAINT contact_form_submission_status_check
                        CHECK (status IN ('received', 'processed', 'spam', 'failed'));
                    END IF;
                END $$;
                """#
        ) { _ in }
    }
}
