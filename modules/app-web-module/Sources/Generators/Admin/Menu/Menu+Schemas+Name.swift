import FeatherOpenAPI

extension Menu.Schemas {
    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MenuNameField" }
        var example: String? = "Header menu"
    }
}
