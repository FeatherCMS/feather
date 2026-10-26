import FeatherOpenAPI

extension MenuItem.Schemas {
    struct CreatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemCreatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}
