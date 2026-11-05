import FeatherOpenAPI

extension Menu.Schemas {
    struct CreatedAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "MenuCreatedAtField" }
        var example: Double? { 1_760_000_000 }
    }
}
