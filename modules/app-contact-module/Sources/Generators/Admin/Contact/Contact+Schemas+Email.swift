import FeatherOpenAPI

extension Contact.Schemas {
    struct Email: StringSchemaRepresentable {
        var openAPIIdentifier: String { "ContactEmailField" }
    }
}
