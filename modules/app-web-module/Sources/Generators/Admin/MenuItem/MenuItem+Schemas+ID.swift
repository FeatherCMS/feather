import FeatherOpenAPI

extension MenuItem.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemIdField" }
        var example: String? { "wmi_home" }
    }
}
