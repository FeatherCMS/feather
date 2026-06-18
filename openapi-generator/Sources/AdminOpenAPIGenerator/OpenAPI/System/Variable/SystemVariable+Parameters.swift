import FeatherOpenAPI

struct SystemVariableIdParameter: PathParameterRepresentable {
    var name: String { "systemVariableId" }
    var description: String? { "SystemVariable id" }
    var schema: any OpenAPISchemaRepresentable {
        SystemVariableIdField().reference()
    }
}
