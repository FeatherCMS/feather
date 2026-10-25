import FeatherOpenAPI

extension Page.Schemas {
    struct CreatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "PageCreatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}
