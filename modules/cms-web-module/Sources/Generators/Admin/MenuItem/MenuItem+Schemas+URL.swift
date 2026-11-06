import FeatherOpenAPI

extension MenuItem.Schemas {
    struct URL: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemURLField" }
        var example: String? { "/" }
    }
}
