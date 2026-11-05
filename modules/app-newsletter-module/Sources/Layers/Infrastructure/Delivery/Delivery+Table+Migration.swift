import FeatherDBAL
import NewsletterModule

extension Delivery.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(
                    name: columns.issueId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.newsletterId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.subscriberEmail.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.status.name,
                    type: .string,
                    constraints: [.notNull, .default(.value("pending"))]
                ),
                .init(name: columns.sentDate.name, type: .timestamp),
                .init(name: columns.failureReason.name, type: .text),
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
                .primaryKey([
                    .init(name: columns.issueId.name, type: .string),
                    .init(name: columns.subscriberEmail.name, type: .string),
                ]),
                .foreignKey(
                    columns: [
                        .init(name: columns.issueId.name, type: .string),
                        .init(name: columns.newsletterId.name, type: .string),
                    ],
                    referencesTable: Issue.Table.name,
                    referencedColumns: [
                        .init(name: Issue.Table.columns.id.name, type: .string),
                        .init(
                            name: Issue.Table.columns.newsletterId.name,
                            type: .string
                        ),
                    ],
                    onDelete: nil,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(
                    name: "newsletter_delivery_status_idx",
                    columns: [.init(name: columns.status.name, type: .string)]
                ),
                .init(
                    name: "newsletter_delivery_issue_newsletter_id_idx",
                    columns: [
                        .init(name: columns.issueId.name, type: .string),
                        .init(name: columns.newsletterId.name, type: .string),
                    ]
                ),
            ]
        )
    }
}
