import FeatherOpenAPI

extension Contact.Field.Schemas {
    struct FieldType: StringSchemaRepresentable {
        var openAPIIdentifier: String { "ContactTypeField" }
        var enumValues: [String]? {
            ["text", "textarea", "select", "radio", "toggle", "hidden"]
        }
    }
}
