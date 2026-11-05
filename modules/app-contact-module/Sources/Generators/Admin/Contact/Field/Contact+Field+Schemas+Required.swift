import FeatherOpenAPI

extension Contact.Field.Schemas {
    struct Required: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "ContactRequiredField" }
    }
}
