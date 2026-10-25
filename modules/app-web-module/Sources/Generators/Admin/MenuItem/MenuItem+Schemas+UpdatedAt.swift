import FeatherOpenAPI

extension MenuItem.Schemas {
    struct UpdatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemUpdatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}
