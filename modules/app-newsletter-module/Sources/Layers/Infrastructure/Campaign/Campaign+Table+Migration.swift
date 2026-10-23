import FeatherDBAL
import NewsletterModule

extension Campaign.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.id.name, type: .string),
                .init(name: columns.key.name, type: .string, constraints: [.notNull, .unique]),
                .init(name: columns.name.name, type: .string, constraints: [.notNull]),
                .init(name: columns.fromEmail.name, type: .string, constraints: [.notNull]),
                .init(name: columns.createdAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
                .init(name: columns.updatedAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
            ],
            constraints: [.primaryKey([.init(name: columns.id.name, type: .string)])],
            indexes: [
                .init(name: "newsletter_campaign_key_idx", columns: [.init(name: columns.key.name, type: .string)])
            ]
        )
    }
}
