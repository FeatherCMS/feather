import FeatherOpenAPI

extension AuthorLink.Schemas {
    struct CreatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkCreatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}
