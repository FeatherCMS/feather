import FeatherOpenAPI

extension Asset.File.Schemas {
    struct NullableText: StringSchemaRepresentable {
        var required: Bool = true
        var nullable: Bool? = true
    }
}
