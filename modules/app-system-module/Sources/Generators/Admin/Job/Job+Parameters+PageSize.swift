import FeatherOpenAPI

extension Job.Parameters {
    struct PageSize: QueryParameterRepresentable {
        var name: String { "pageSize" }
        var required: Bool { false }
        var description: String? {
            "Defaults to 100; values are clamped to 1-100"
        }
        var schema: any OpenAPISchemaRepresentable {
            Job.Schemas.PageSize().reference()
        }
    }
}
