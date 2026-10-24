import FeatherOpenAPI

extension Contact.Field.Schemas {
    struct Label: StringSchemaRepresentable {
        var openAPIIdentifier: String { "ContactLabelField" }
    }
}
