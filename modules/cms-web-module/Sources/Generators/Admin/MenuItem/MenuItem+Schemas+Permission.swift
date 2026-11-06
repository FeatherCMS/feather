import FeatherOpenAPI

extension MenuItem.Schemas {
    struct Permission: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemPermissionField" }
        var example: String? { "" }
    }
}
