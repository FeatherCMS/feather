import FeatherOpenAPI

extension Contact.Form.Field {
    struct AllowedValues: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "ContactAllowedValuesSchema" }
        var items: (any SchemaRepresentable)? { Name() }
    }
}
