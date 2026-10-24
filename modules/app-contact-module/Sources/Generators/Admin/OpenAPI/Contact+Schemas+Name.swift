import FeatherOpenAPI

extension Contact.Schemas {
    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "ContactNameField" }
    }
}
