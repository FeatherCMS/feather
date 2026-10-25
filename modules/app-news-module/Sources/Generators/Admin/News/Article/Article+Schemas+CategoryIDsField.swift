import FeatherOpenAPI

extension Article.Schemas {
    struct CategoryIDsField: ArraySchemaRepresentable {
        var items: (any SchemaRepresentable)? {
            StringField().reference()
        }
    }
}
