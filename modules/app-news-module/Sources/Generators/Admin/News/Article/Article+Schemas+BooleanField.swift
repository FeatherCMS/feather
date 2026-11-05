import FeatherOpenAPI

extension Article.Schemas {
    struct BooleanField: BoolSchemaRepresentable {
        var example: Bool? = false
    }
}
