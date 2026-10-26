import FeatherOpenAPI

extension Metadata.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "WebMetadataUpdateMask" }
        var example: String? { "title,slug,status,publicationDate" }
    }
}
