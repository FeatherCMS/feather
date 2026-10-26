import FeatherDBAL
import NewsletterModule

extension Issue.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.id.name, type: .string),
                .init(
                    name: columns.newsletterId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.subject.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.previewText.name,
                    type: .string,
                    constraints: [.notNull, .default(.value(""))]
                ),
                .init(
                    name: columns.content.name,
                    type: .text,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.status.name,
                    type: .string,
                    constraints: [.notNull, .default(.value("draft"))]
                ),
                .init(name: columns.scheduledDate.name, type: .timestamp),
                .init(name: columns.sentDate.name, type: .timestamp),
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
                .unique([
                    .init(name: columns.id.name, type: .string),
                    .init(name: columns.newsletterId.name, type: .string),
                ]),
                .foreignKey(
                    columns: [
                        .init(name: columns.newsletterId.name, type: .string)
                    ],
                    referencesTable: Campaign.Table.name,
                    referencedColumns: [
                        .init(
                            name: Campaign.Table.columns.id.name,
                            type: .string
                        )
                    ],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(
                    name: "newsletter_issue_newsletter_id_idx",
                    columns: [
                        .init(name: columns.newsletterId.name, type: .string)
                    ]
                )
            ]
        )
    }
}
