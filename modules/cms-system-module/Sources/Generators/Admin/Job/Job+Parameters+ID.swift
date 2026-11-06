import FeatherOpenAPI

extension Job.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "SystemJobIdParameter" }
        var name: String { "systemJobId" }
        var description: String? { "Worker job id" }
        var schema: any OpenAPISchemaRepresentable {
            Job.Schemas.ID().reference()
        }
    }
}
