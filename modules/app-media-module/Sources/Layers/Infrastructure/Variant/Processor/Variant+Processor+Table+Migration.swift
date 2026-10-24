import FeatherDBAL
import MediaModule

extension Variant.Processor.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.id.name, type: .string),
                .init(name: columns.variantId.name, type: .string, constraints: [.notNull]),
                .init(name: columns.name.name, type: .string, constraints: [.notNull]),
                .init(name: columns.matchExtensions.name, type: .text, constraints: [.notNull]),
                .init(name: columns.commandTemplate.name, type: .text, constraints: [.notNull]),
                .init(name: columns.isActive.name, type: .boolean, constraints: [.notNull, .default(.value(true))]),
                .init(name: columns.createdAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
                .init(name: columns.updatedAt.name, type: .timestamp, constraints: [.notNull, .default(.currentTimestamp)]),
            ],
            constraints: [
                .primaryKey([.init(name: columns.id.name, type: .string)]),
                .unique([
                    .init(name: columns.variantId.name, type: .string),
                    .init(name: columns.name.name, type: .string),
                ]),
                .unique([
                    .init(name: columns.variantId.name, type: .string),
                    .init(name: columns.id.name, type: .string),
                ]),
                .foreignKey(
                    columns: [.init(name: columns.variantId.name, type: .string)],
                    referencesTable: Variant.Table.name,
                    referencedColumns: [.init(name: Variant.Table.columns.id.name, type: .string)],
                    onDelete: .cascade,
                    onUpdate: nil
                ),
            ],
            indexes: []
        )
    }
}
