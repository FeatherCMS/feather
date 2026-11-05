import FeatherOpenAPI

extension MenuItem.Schemas {
    struct Authentication: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemAuthenticationField" }
        var example: String? { "any" }
    }
}
