import FeatherOpenAPI

extension Variable.Schemas {
    struct Value: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableValueField" }
        var example: String? = "UTC"
    }
}
