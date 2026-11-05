import FeatherOpenAPI

extension Variable.Schemas {
    struct Limit: IntSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableListLimit" }
        var description: String? {
            "Maximum number of results. Defaults to 20; values are clamped to 1-100."
        }
        var defaultValue: Int? = 20
        var example: Int? = 20
    }
}
