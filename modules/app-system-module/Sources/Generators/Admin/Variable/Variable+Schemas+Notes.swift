import FeatherOpenAPI

extension Variable.Schemas {
    struct Notes: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableNotesField" }
        var example: String? = "Application default timezone."
    }
}
