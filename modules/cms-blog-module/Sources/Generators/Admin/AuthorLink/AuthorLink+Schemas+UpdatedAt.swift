import FeatherOpenAPI

extension AuthorLink.Schemas {
    struct UpdatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkUpdatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}
