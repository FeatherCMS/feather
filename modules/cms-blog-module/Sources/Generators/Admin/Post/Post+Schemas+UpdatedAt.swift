import FeatherOpenAPI

extension Post.Schemas {
    struct UpdatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "BlogPostUpdatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}
