import FeatherOpenAPI

extension Contact.Schemas {
    struct JSON: SchemaRepresentable {
        var openAPIIdentifier: String { "AppContactJSONField" }

        func openAPISchema() -> JSONSchema {
            .object(
                format: .generic,
                required: required,
                nullable: nullable,
                permissions: nil,
                deprecated: deprecated,
                title: title,
                description: description,
                discriminator: nil,
                externalDocs: nil,
                minProperties: nil,
                maxProperties: nil,
                properties: [:],
                additionalProperties: .schema(JSONSchema.string),
                allowedValues: nil,
                defaultValue: nil,
                example: nil
            )
        }
    }
}
