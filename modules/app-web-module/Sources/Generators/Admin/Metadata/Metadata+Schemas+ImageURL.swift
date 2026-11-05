import FeatherOpenAPI

extension Metadata.Schemas {
    struct ImageURL: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataImageURLField" }
        var example: String? = "https://example.com/image.jpg"
    }
}
