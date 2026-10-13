import FeatherOpenAPI

struct SystemVariableIDParameter: PathParameterRepresentable {
    var name: String { "systemVariableId" }
    var description: String? { "SystemVariable id" }
    var schema: any OpenAPISchemaRepresentable {
        SystemVariableIDField().reference()
    }
}
