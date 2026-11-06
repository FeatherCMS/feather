import FeatherOpenAPI

extension Asset.File.Schemas {
    struct SlugPath: StringSchemaRepresentable {
        var example: String? { "posts/cover-image" }
    }
}
