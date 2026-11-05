import FeatherOpenAPI

extension Variable.Schemas {
    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableNameField" }
        var example: String? = "default_timezone"
    }
}
