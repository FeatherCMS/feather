import BlogModule
import FeatherDBAL

extension AuthorLink.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: Self.name,
            columns: [
                .init(
                    name: columns.id.name,
                    type: .string,
                    constraints: [.primaryKey]
                ),
                .init(
                    name: columns.authorId.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.label.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.url.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.priority.name,
                    type: .integer,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.isBlank.name,
                    type: .boolean,
                    constraints: [.notNull, .default(.value(false))]
                ),
                .init(
                    name: columns.permission.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.notes.name,
                    type: .text,
                    constraints: [.notNull]
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
                .foreignKey(
                    columns: [
                        .init(name: columns.authorId.name, type: .string)
                    ],
                    referencesTable: Author.Table.name,
                    referencedColumns: [
                        .init(name: Author.Table.columns.id.name, type: .string)
                    ],
                    onDelete: .cascade,
                    onUpdate: nil
                )
            ],
            indexes: [
                .init(
                    name: "blog_author_link_author_id_idx",
                    columns: [.init(name: columns.authorId.name, type: .string)]
                )
            ]
        )
    }
}
