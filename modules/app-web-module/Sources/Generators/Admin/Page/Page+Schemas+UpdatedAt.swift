import FeatherOpenAPI

extension Page.Schemas {
    struct UpdatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "PageUpdatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}
