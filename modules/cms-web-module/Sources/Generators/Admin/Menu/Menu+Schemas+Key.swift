import FeatherOpenAPI

extension Menu.Schemas {
    struct Key: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MenuKeyField" }
        var example: String? = "header"
    }
}
