import FeatherOpenAPI

extension Menu.Schemas {
    struct Notes: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MenuNotesField" }
        var example: String? = "Primary site navigation."
    }
}
