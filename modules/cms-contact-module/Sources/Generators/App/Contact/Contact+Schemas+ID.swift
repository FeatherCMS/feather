import FeatherOpenAPI

extension Contact.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AppContactKeyField" }
    }
}
