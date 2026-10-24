import FeatherDBAL
import NewsletterModule

extension Subscriber.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.newsletterId.name, type: .string, constraints: [.notNull]),
                .init(name: columns.email.name, type: .string, constraints: [.notNull]),
                .init(name: columns.status.name, type: .string, constraints: [.notNull, .default(.value("subscribed"))]),
                .init(name: columns.subscriptionDate.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
                .init(name: columns.unsubscriptionDate.name, type: .timestamp),
                .init(name: columns.firstName.name, type: .string, constraints: [.notNull, .default(.value(""))]),
                .init(name: columns.lastName.name, type: .string, constraints: [.notNull, .default(.value(""))]),
                .init(name: columns.confirmedAt.name, type: .timestamp),
                .init(name: columns.unsubscribeToken.name, type: .string, constraints: [.unique]),
                .init(name: columns.source.name, type: .string),
                .init(name: columns.lastSentAt.name, type: .timestamp),
                .init(name: columns.createdAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
                .init(name: columns.updatedAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
            ],
            constraints: [
                .primaryKey([
                    .init(name: columns.newsletterId.name, type: .string),
                    .init(name: columns.email.name, type: .string),
                ]),
                .foreignKey(
                    columns: [.init(name: columns.newsletterId.name, type: .string)],
                    referencesTable: Campaign.Table.name,
                    referencedColumns: [.init(name: Campaign.Table.columns.id.name, type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
            ],
            indexes: [
                .init(name: "newsletter_subscriber_email_idx", columns: [.init(name: columns.email.name, type: .string)])
            ]
        )
    }
}
