import FeatherOpenAPI

extension Permission.Parameters {
    struct IDs: QueryParameterRepresentable {
        var name: String { "ids" }
        var required: Bool { false }
        var description: String? { "Filter by one or more permission IDs" }
        var schema: any OpenAPISchemaRepresentable {
            Permission.Query.Schemas.Filter().reference()
        }
    }
}
