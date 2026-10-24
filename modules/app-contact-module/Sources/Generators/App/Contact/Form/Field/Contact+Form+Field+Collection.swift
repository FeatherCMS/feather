import FeatherOpenAPI

extension Contact.Form.Field {
    struct Collection: ArraySchemaRepresentable {
        var items: (any SchemaRepresentable)? { Schema().reference() }
    }
}
