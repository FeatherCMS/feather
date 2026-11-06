import FeatherOpenAPI

extension Menu.Schemas {
    struct UpdatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "MenuUpdatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}
