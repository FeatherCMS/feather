import FeatherOpenAPI

extension MenuItem.Schemas {
    struct Label: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemLabelField" }
        var example: String? { "Home" }
    }
}
