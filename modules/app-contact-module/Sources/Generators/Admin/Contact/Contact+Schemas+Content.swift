import FeatherOpenAPI

extension Contact.Schemas {
    struct Content: StringSchemaRepresentable {
        var openAPIIdentifier: String { "ContactContentField" }
    }
}
