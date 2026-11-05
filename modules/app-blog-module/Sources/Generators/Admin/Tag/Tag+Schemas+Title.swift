import FeatherOpenAPI

extension Tag.Schemas {
    struct Title: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogTagTitleField" }
        var example: String? = "Swift"
    }
}
