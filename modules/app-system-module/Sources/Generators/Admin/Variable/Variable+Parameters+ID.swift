import FeatherOpenAPI

extension Variable.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "SystemVariableIDParameter" }
        var name: String { "systemVariableId" }
        var description: String? { "SystemVariable ID" }
        var schema: any OpenAPISchemaRepresentable {
            Variable.Schemas.ID().reference()
        }
    }
}
