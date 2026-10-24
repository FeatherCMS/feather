import FeatherOpenAPI

extension Variable.Schemas {
    struct Search: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableSearch" }
        var example: String? = "mail"
    }
}
