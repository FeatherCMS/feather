import FeatherOpenAPI

extension Variable.Parameters {
    struct Search: QueryParameterRepresentable {
        var name: String { "search" }
        var required: Bool { false }
        var description: String? {
            "Search across variable keys, values, names, and notes"
        }
        var schema: any OpenAPISchemaRepresentable {
            Variable.Schemas.Search().reference()
        }
    }
}
