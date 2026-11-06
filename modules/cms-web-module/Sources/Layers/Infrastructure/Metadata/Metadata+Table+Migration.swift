import FeatherDBAL
import WebDomain
import WebModule

extension Metadata.Table {
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
                    name: columns.referenceType.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.referenceID.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.template.name,
                    type: .string,
                    constraints: [.notNull, .default(.value("default"))]
                ),
                .init(
                    name: columns.slug.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(
                    name: columns.publicationDate.name,
                    type: .timestamp,
                    constraints: [.notNull, .default(.currentTimestamp)]
                ),
                .init(name: columns.expirationDate.name, type: .timestamp),
                .init(
                    name: columns.status.name,
                    type: .string,
                    constraints: [.notNull]
                ),
                .init(name: columns.titleOverride.name, type: .string),
                .init(name: columns.excerptOverride.name, type: .string),
                .init(name: columns.imageURLOverride.name, type: .string),
                .init(name: columns.canonicalURL.name, type: .string),
                .init(
                    name: columns.noIndex.name,
                    type: .boolean,
                    constraints: [.notNull, .default(.value(false))]
                ),
                .init(name: columns.primaryKeyword.name, type: .string),
                .init(name: columns.cssCodeInjection.name, type: .text),
                .init(name: columns.javascriptCodeInjection.name, type: .text),
                .init(
                    name: columns.structuredDataCodeInjection.name,
                    type: .text
                ),
                .init(name: columns.templateData.name, type: .text),
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
            indexes: [
                .init(
                    name: "web_metadata_reference_owner_idx",
                    columns: [
                        .init(name: columns.referenceType.name, type: .string),
                        .init(name: columns.referenceID.name, type: .string),
                    ],
                    isUnique: true
                ),
                .init(
                    name: "web_metadata_slug_idx",
                    columns: [.init(name: columns.slug.name, type: .string)],
                    isUnique: true
                ),
            ]
        )
    }
}
