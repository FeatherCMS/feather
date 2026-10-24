import FeatherOpenAPI

extension Contact.Field.Schemas {
    struct AllowedValue: StringSchemaRepresentable {
        var openAPIIdentifier: String { "ContactAllowedValueField" }
    }
}
