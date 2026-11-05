import FeatherOpenAPI

extension MenuItem.Schemas {
    struct IsBlank: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemIsBlankField" }
        var example: Bool? { false }
    }
}
