import FeatherOpenAPI

struct SystemJobIdParameter: PathParameterRepresentable {
    var name: String { "systemJobId" }
    var description: String? { "Worker job id" }
    var schema: any OpenAPISchemaRepresentable {
        SystemJobIdField().reference()
    }
}
