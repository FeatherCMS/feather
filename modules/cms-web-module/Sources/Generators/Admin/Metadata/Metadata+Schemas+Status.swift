import FeatherOpenAPI

extension Metadata.Schemas {
    struct Status: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataStatusField" }
        var example: String? = "draft"
        var enumValues: [String]? = ["draft", "published", "archived"]
    }
}
