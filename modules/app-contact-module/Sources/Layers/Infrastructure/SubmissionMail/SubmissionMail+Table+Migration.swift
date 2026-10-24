import FeatherDBAL
import ContactModule

extension SubmissionMail.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.id.name, type: .string),
                .init(name: columns.formId.name, type: .string, constraints: [.notNull]),
                .init(name: columns.mailFrom.name, type: .string, constraints: [.notNull]),
                .init(name: columns.mailTo.name, type: .string, constraints: [.notNull]),
                .init(name: columns.subject.name, type: .string, constraints: [.notNull]),
                .init(name: columns.additionalHeaders.name, type: .text, constraints: [.notNull, .default(.value(""))]),
                .init(name: columns.messageBody.name, type: .text, constraints: [.notNull]),
                .init(name: columns.createdAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
                .init(name: columns.updatedAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
            ],
            constraints: [
                .primaryKey([.init(name: columns.id.name, type: .string)]),
                .foreignKey(
                    columns: [.init(name: columns.formId.name, type: .string)],
                    referencesTable: Form.Table.name,
                    referencedColumns: [.init(name: Form.Table.columns.id.name, type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(name: "contact_form_mail_form_id_idx", columns: [.init(name: columns.formId.name, type: .string), .init(name: columns.id.name, type: .string)])
            ]
        )
    }
}
