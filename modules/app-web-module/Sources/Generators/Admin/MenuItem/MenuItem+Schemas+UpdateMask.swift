import FeatherOpenAPI

extension MenuItem.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "WebMenuItemUpdateMask" }
        var example: String? { "label,url,notes" }
    }
}
