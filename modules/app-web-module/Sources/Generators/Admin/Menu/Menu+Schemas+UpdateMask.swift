import FeatherOpenAPI

extension Menu {
    enum Schemas {
        struct UpdateMask: StringSchemaRepresentable {
            var openAPIIdentifier: String { "WebMenuUpdateMask" }
            var example: String? { "key,name,notes" }
        }
    }
}
