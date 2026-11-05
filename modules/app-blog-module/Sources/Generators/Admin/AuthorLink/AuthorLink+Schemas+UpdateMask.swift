import FeatherOpenAPI

extension AuthorLink.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkUpdateMaskField" }
        var example: String? = "label,url"
    }
}
