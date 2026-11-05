import FeatherOpenAPI

extension Menu.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MenuIdField" }
        var example: String? = "wm_header"
    }
}
