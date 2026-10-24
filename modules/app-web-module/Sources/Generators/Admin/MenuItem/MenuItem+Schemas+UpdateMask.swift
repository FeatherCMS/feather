import FeatherOpenAPI

extension MenuItem {
    enum Schemas {
        struct UpdateMask: StringSchemaRepresentable {
            var openAPIIdentifier: String { "WebMenuItemUpdateMask" }
            var example: String? { "label,url,notes" }
        }
    }
}
