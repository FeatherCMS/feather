import FeatherOpenAPI

extension Variable.Schemas {
    struct Key: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableKeyField" }
        var example: String? = "sys_variable_timezone"
    }
}
