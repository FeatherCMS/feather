import FeatherOpenAPI

extension Variable.Parameters {
    struct IDs: QueryParameterRepresentable {
        var name: String { "ids" }
        var required: Bool { false }
        var description: String? { "Filter by one or more variable IDs" }
        var schema: any OpenAPISchemaRepresentable {
            Variable.Query.Schemas.Filter().reference()
        }
    }
}
