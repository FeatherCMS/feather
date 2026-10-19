import FeatherOpenAPI

extension Job.Parameters {

    struct PageSize: QueryParameterRepresentable {
        var name: String { "pageSize" }
        var required: Bool { false }
        var description: String? { "Defaults to 100; values are clamped to 1-100" }
        var schema: any OpenAPISchemaRepresentable {
            Job.Schemas.PageSize().reference()
        }
    }

    struct PageNumber: QueryParameterRepresentable {
        var name: String { "pageNumber" }
        var required: Bool { false }
        var description: String? { "Defaults to 1; one-based, values below 1 use page 1" }
        var schema: any OpenAPISchemaRepresentable {
            Job.Schemas.PageNumber().reference()
        }
    }

    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "SystemJobIdParameter" }
        var name: String { "systemJobId" }
        var description: String? { "Worker job id" }
        var schema: any OpenAPISchemaRepresentable {
            Job.Schemas.ID().reference()
        }
    }
}
