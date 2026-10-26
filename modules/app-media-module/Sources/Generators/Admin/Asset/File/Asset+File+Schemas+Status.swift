import FeatherOpenAPI

extension Asset.File.Schemas {
    struct Status: StringSchemaRepresentable {
        var example: String? { "ready" }
    }
}
