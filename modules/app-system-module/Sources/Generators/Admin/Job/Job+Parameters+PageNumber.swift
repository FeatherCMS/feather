import FeatherOpenAPI

extension Job.Parameters {
    struct PageNumber: QueryParameterRepresentable {
        var name: String { "pageNumber" }
        var required: Bool { false }
        var description: String? {
            "Defaults to 1; one-based, values below 1 use page 1"
        }
        var schema: any OpenAPISchemaRepresentable {
            Job.Schemas.PageNumber().reference()
        }
    }
}
