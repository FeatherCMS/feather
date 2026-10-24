import FeatherOpenAPI

extension Metadata {
    enum Schemas {
        struct UpdateMask: StringSchemaRepresentable {
            var openAPIIdentifier: String { "WebMetadataUpdateMask" }
            var example: String? { "title,slug,status,publicationDate" }
        }
    }
}
