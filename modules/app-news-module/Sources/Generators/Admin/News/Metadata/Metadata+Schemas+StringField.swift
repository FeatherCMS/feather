import FeatherOpenAPI

extension Metadata.Schemas {
    struct StringField: StringSchemaRepresentable {
        var example: String? = "example"
    }
}
