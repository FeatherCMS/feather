import FeatherOpenAPI

extension Variant.Schemas {
    struct Command: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantCommandField" }
        var example: String? =
            "convert {input.fullname} -resize 256x256 {output.fullname}"
    }
}
