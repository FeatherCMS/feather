import FeatherOpenAPI

extension Asset.File.Schemas {
    struct ContentType: StringSchemaRepresentable {
        var example: String? { "image/jpeg" }
    }
}
