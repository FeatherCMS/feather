import FeatherOpenAPI

extension Author.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorUpdateMaskField" }
        var example: String? = "name,excerpt"
    }
}
