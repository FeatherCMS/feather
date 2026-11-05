import FeatherOpenAPI

extension Permission.Parameters {
    struct Search: QueryParameterRepresentable {
        var name: String { "search" }
        var required: Bool { false }
        var description: String? {
            "Search across permission keys, names, and notes"
        }
        var schema: any OpenAPISchemaRepresentable {
            Permission.Schemas.Search().reference()
        }
    }
}
