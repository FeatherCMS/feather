import FeatherDBAL
import MediaModule

extension StorageObject.Table {
    static var tableCreationSchema: DatabaseTableSchema {
        .init(
            name: name,
            columns: [
                .init(name: columns.id.name, type: .string),
                .init(
                    name: columns.key.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.fileExtension.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.contentType.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.sizeInBytes.name,
                    type: .integer,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.createdAt.name,
                    type: .timestamp,
                    constraints: [.notNull, .default(.currentTimestamp)]
                ),
            ],
            constraints: [
                .primaryKey([.init(name: columns.id.name, type: .string)])
            ],
            indexes: [
                .init(
                    name: "media_storage_object_extension_idx",
                    columns: [
                        .init(name: columns.fileExtension.name, type: .string)
                    ]
                )
            ]
        )
    }
}
