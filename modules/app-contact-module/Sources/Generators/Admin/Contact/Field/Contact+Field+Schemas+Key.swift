import FeatherOpenAPI

extension Contact.Field.Schemas {
    struct Key: StringSchemaRepresentable {
        var openAPIIdentifier: String { "ContactKeyField" }
    }
}
